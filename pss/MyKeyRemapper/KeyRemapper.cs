using System;
using System.Diagnostics;
using System.Diagnostics.Eventing.Reader;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace MyKeyRemapper
{
    public class KeyRemapper
    {
        // REF:
        // Native interoperability best practies
        // https://learn.microsoft.com/en-us/dotnet/standard/native-interop/best-practices
        // ネイティブ相互運用性のベストプラクティス
        // https://learn.microsoft.com/ja-jp/dotnet/standard/native-interop/best-practices

        // REF:
        // LowLevelKeyboardProc callback function
        // https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/ms644985(v=vs.85)
        delegate int LowLevelKeyboardProc(int nCode, Int32 wParam, ref KBDLLHOOKSTRUCT lParam);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool UnhookWindowsHookEx(IntPtr hhk);

        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        static extern IntPtr GetModuleHandle(string lpModuleName);

        IntPtr hookPtr = IntPtr.Zero;
        LowLevelKeyboardProc hookProc;   // GC でデリゲートが回収されるのを防ぐため保持する

        [StructLayout(LayoutKind.Sequential)]
        struct MOUSEINPUT
        {
            public int dx;
            public int dy;
            public int mouseData;
            public int dwFlags;
            public int time;
            public IntPtr dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        struct KEYBDINPUT
        {
            public short wVk;
            public short wScan;
            public int dwFlags;
            public int time;
            public IntPtr dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        struct KBDLLHOOKSTRUCT
        {
            public uint vkCode;         // DWORD
            public uint scanCode;       // DWORD
            public uint flags;          // DWORD
            public uint time;           // DWORD
            public UIntPtr dwExtraInfo; // ULONG_PTR
        }

        [StructLayout(LayoutKind.Sequential)]
        struct HARDWAREINPUT
        {
            public int uMsg;
            public short wParamL;
            public short wParamH;
        }

        [StructLayout(LayoutKind.Explicit)]
        struct INPUT
        {
            [FieldOffset(0)]
            public int type;
            [FieldOffset(8)]
            public MOUSEINPUT mi;
            [FieldOffset(8)]
            public KEYBDINPUT ki;
            [FieldOffset(8)]
            public HARDWAREINPUT hi;
        }

        [DllImport("user32.dll")]
        static extern void SendInput(int nInputs, ref INPUT pInputs, int cbsize);

        const int ACCEPT = 0;
        const int DISPOSE = 1;

        // WM_KEYDOWN 0x0100
        const int KEY_DOWN = 256;
        const int KEY_DOWN2 = 260;  // Alt(Menu)キー押下時
        // WM_KEYUP 0x0101
        const int KEY_UP = 257;

        const Keys SEQ_KEY = Keys.Insert;

        bool modeKeyLog = false;
        bool isVimMode = false;
        int nestLevel = -1;
        int downCountOfSeqKey = 0;
        int downCountOfLShift = 0;
        int downCountOfLCtrl = 0;
        int downCountOfLAlt = 0;
        int downCountOfLWin = 0;
        int downCountOfRCtrl = 0;
        int downCountOfRAlt = 0;
        int downCountOfRShift = 0;

        Keys prevKey;
        int prevEvent;
        int repeatCount = 0;

        public void Hook(bool modeKeyLog = false)
        {
            this.modeKeyLog = modeKeyLog;
            using (Process curProcess = Process.GetCurrentProcess())
            using (ProcessModule curModule = curProcess.MainModule)
            {
                hookPtr = SetWindowsHookEx(
                    13,                 // Hook Event Type : 13 is Keyboard Hook (WH_KEYBOARD_LL)
                    (hookProc = HookCallbackMain),   // Key Remap Logic
                    GetModuleHandle(curModule.ModuleName),
                    0);                 // Hook Target Thread : 0 is All Threads
            }
        }

        public void HookEnd()
        {
            UnhookWindowsHookEx(hookPtr);
            hookPtr = IntPtr.Zero;
        }

        int KeyDown(Keys vk)
        {
            var input = new INPUT
            {
                type = 1,
                ki = new KEYBDINPUT
                {
                    wVk = (short)vk,
                    wScan = 0,
                    dwFlags = 0,
                    time = 0,
                    dwExtraInfo = IntPtr.Zero
                }
            };
            SendInput(1, ref input, Marshal.SizeOf(input));
            return DISPOSE;
        }

        int KeyUp(Keys vk)
        {
            var input = new INPUT
            {
                type = 1,
                ki = new KEYBDINPUT
                {
                    wVk = (short)vk,
                    wScan = 0,
                    dwFlags = 2,
                    time = 0,
                    dwExtraInfo = IntPtr.Zero
                }
            };
            SendInput(1, ref input, Marshal.SizeOf(input));
            return DISPOSE;
        }

        int KeyPress(Keys vk)
        {
            KeyDown(vk);
            KeyUp(vk);
            return DISPOSE;
        }

        void FreePassKeyPress(
            Keys vk,
            bool LShift = false,
            bool LCtrl = false,
            bool LAlt = false,
            bool LWin = false,
            bool RAlt = false,
            bool RShift = false)
        {
            var needPressLShift = LShift && downCountOfLShift == 0;
            var needPressLCtrl = LCtrl && downCountOfLCtrl == 0;
            var needPressLAlt = LAlt && downCountOfLAlt == 0;
            var needPressLWin = LWin && downCountOfLWin == 0;
            var needPressRAlt = RAlt && downCountOfRAlt == 0;
            var needPressRShift = RShift && downCountOfRShift == 0;

            var jumpCursor = (vk == Keys.Home || vk == Keys.End || vk == Keys.PageUp || vk == Keys.PageDown);
            var needReleaseLCtrl = jumpCursor && downCountOfLCtrl > 0;
            var needReleaseLAlt = jumpCursor && downCountOfLAlt > 0;
            var needReleaseRAlt = jumpCursor && downCountOfRAlt > 0;

            KeyDown(SEQ_KEY);
            if (needReleaseLCtrl) KeyUp(Keys.LControlKey);
            if (needReleaseLAlt) KeyUp(Keys.LMenu);
            if (needReleaseRAlt) KeyUp(Keys.RMenu);
            //  KeyUp(Keys.RControlKey);
            if (needPressLShift) KeyDown(Keys.LShiftKey);
            if (needPressLCtrl) KeyDown(Keys.LControlKey);
            if (needPressLAlt) KeyDown(Keys.LMenu);
            if (needPressLWin) KeyDown(Keys.LWin);
            if (needPressRAlt) KeyDown(Keys.RMenu);
            if (needPressRShift) KeyDown(Keys.RShiftKey);
            KeyPress(vk);
            if (needPressLShift) KeyUp(Keys.LShiftKey);
            if (needPressLCtrl) KeyUp(Keys.LControlKey);
            if (needPressLAlt) KeyUp(Keys.LMenu);
            if (needPressLWin) KeyUp(Keys.LWin);
            if (needPressRAlt) KeyUp(Keys.RMenu);
            if (needPressRShift) KeyUp(Keys.RShiftKey);
            //  KeyDown(Keys.RControlKey);
            if (needReleaseLCtrl) KeyDown(Keys.LControlKey);
            if (needReleaseLAlt) KeyDown(Keys.LMenu);
            if (needReleaseRAlt) KeyDown(Keys.RMenu);
            KeyUp(SEQ_KEY);
        }

        void EnterVimMode()
        {
            isVimMode = true;
            repeatCount = 0;
            Console.WriteLine("Vim Mode : " + isVimMode);
        }

        void ExitVimMode()
        {
            isVimMode = false;
            repeatCount = 0;
            Console.WriteLine("Vim Mode : " + isVimMode);
        }

        void ToggleVimMode()
        {
            isVimMode = !isVimMode;
            repeatCount = 0;
            Console.WriteLine("Vim Mode : " + isVimMode);
        }

        int HookCallback_MonitoringOnly(int nCode, Int32 wParam, ref KBDLLHOOKSTRUCT lParam)
        {
            Console.WriteLine("nCode:" + nCode + "\twParam:" + wParam + "\tlParam[vkCode:" + lParam.vkCode + ",scanCode:" + lParam.scanCode + ",flags:" + lParam.flags + ",time:" + lParam.time + ",]");
            return ACCEPT;
        }

        bool UpdateDownCount(int keyEvent, ref int downCounter)
        {
            if (keyEvent == KEY_DOWN || keyEvent == KEY_DOWN2)
                downCounter++;
            else if (keyEvent == KEY_UP)
                downCounter = 0;
            else
                return false;

            return true;
        }

        int HookCallbackMain(int nCode, Int32 wParam, ref KBDLLHOOKSTRUCT lParam)
        {
            nestLevel++;
            bool isAccept = true;

            Keys curKey = (Keys)(short)lParam.vkCode;
            int curEvent = wParam;

            if (modeKeyLog) PutKeyLogBegin(curKey, curEvent);

            // 左の全修飾キー（LShift + LCtrl + LAlt + LWin）+ End の同時押しでプログラムを終了する
            if (curKey == Keys.End && (curEvent == KEY_DOWN || curEvent == KEY_DOWN2)
                && downCountOfLShift > 0 && downCountOfLCtrl > 0
                && downCountOfLAlt > 0 && downCountOfLWin > 0)
            {
                Console.WriteLine("\u7d42\u4e86\u30ad\u30fc\uff08LShift+LCtrl+LAlt+LWin+End\uff09\u3092\u691c\u51fa\u3002\u7d42\u4e86\u3057\u307e\u3059\u3002");
                Application.Exit();     // Application.Run() のメッセージループを抜ける
                isAccept = false;       // End キーは通さず握りつぶす
                if (modeKeyLog) PutKeyLog(curKey, curEvent, isAccept);
                nestLevel--;
                return DISPOSE;
            }

            switch (curKey)
            {
                case SEQ_KEY:
                    UpdateDownCount(curEvent, ref downCountOfSeqKey);
                    isAccept = false;
                    break;
                case Keys.RControlKey:
                    UpdateDownCount(curEvent, ref downCountOfRCtrl);
                    isAccept = false;
                    break;
                case Keys.LShiftKey:
                    UpdateDownCount(curEvent, ref downCountOfLShift);
                    break;
                case Keys.LControlKey:
                    UpdateDownCount(curEvent, ref downCountOfLCtrl);
                    break;
                case Keys.LMenu:
                    UpdateDownCount(curEvent, ref downCountOfLAlt);
                    break;
                case Keys.LWin:
                    UpdateDownCount(curEvent, ref downCountOfLWin);
                    break;
                case Keys.RMenu:
                    UpdateDownCount(curEvent, ref downCountOfRAlt);
                    break;
                case Keys.RShiftKey:
                    UpdateDownCount(curEvent, ref downCountOfRShift);
                    break;
                default:
                    if (downCountOfSeqKey > 0)
                    {
                        isAccept &= true;
                    }
                    else if (downCountOfRCtrl > 0)
                    {
                        switch (curKey)
                        {
                            case Keys.OemOpenBrackets:
                                if (curEvent == KEY_UP)
                                    FreePassKeyPress(Keys.Escape);
                                break;
                            case Keys.Space:
                                if (curEvent == KEY_DOWN)
                                    FreePassKeyPress(Keys.Back);
                                break;
                            case Keys.H:
                                if (curEvent == KEY_DOWN)
                                {
                                    if (downCountOfLCtrl > 0 && downCountOfLAlt > 0)
                                        FreePassKeyPress(Keys.Home);
                                    else
                                        FreePassKeyPress(Keys.Left);
                                }
                                break;
                            case Keys.J:
                                if (curEvent == KEY_DOWN)
                                {
                                    if (downCountOfLCtrl > 0 && downCountOfLAlt > 0)
                                        FreePassKeyPress(Keys.PageDown);
                                    else
                                        FreePassKeyPress(Keys.Down);
                                }
                                break;
                            case Keys.K:
                                if (curEvent == KEY_DOWN)
                                {
                                    if (downCountOfLCtrl > 0 && downCountOfLAlt > 0)
                                        FreePassKeyPress(Keys.PageUp);
                                    else
                                        FreePassKeyPress(Keys.Up);
                                }
                                break;
                            case Keys.L:
                                if (curEvent == KEY_DOWN)
                                {
                                    if (downCountOfLCtrl > 0 && downCountOfLAlt > 0)
                                        FreePassKeyPress(Keys.End);
                                    else
                                        FreePassKeyPress(Keys.Right);
                                }
                                break;
                            case Keys.M:
                                if (curEvent == KEY_UP)
                                    FreePassKeyPress(Keys.Apps);
                                break;
                            case Keys.Q:
                                if (curEvent == KEY_UP)
                                    FreePassKeyPress(Keys.F4, LAlt: true);
                                break;
                            case Keys.Oemcomma:
                                if (curEvent == KEY_DOWN)
                                    FreePassKeyPress(Keys.Tab, LShift: true);
                                break;
                            case Keys.OemPeriod:
                                if (curEvent == KEY_DOWN)
                                    FreePassKeyPress(Keys.Tab);
                                break;
                            default:
                                if (curEvent == KEY_UP)
                                    FreePassKeyPress(curKey, LCtrl: true);
                                break;
                        }
                        isAccept = false;
                    }
                    break;
            }

            if (modeKeyLog) PutKeyLog(curKey, curEvent, isAccept);

            nestLevel--;
            return isAccept ? ACCEPT : DISPOSE;
        }

        void PutKeyLogBegin(Keys key, int keyEvent)
        {
            ChangeConsoleColorForBegin(keyEvent);
            Console.WriteLine(
                "[" + DateTime.Now.ToString("HH:mm:ss") + "] " + GetDownState() + " " + GetIndent() + GetEventStr(keyEvent) + " " + key);
        }

        void PutKeyLog(Keys key, int keyEvent, bool isAccept)
        {
            ChangeConsoleColor(keyEvent, isAccept);
            Console.WriteLine(
                "[" + DateTime.Now.ToString("HH:mm:ss") + "] " + GetDownState() + " " + GetIndent() + (isAccept ? "\u25CB" : "\u00D7") + " " + key);
        }

        string GetIndent()
        {
            return "".PadRight(nestLevel * 2, ' ');
        }

        void ChangeConsoleColorForBegin(int keyEvent)
        {
            ConsoleColor fc;

            if (keyEvent == KEY_DOWN)
                fc = ConsoleColor.White;
            else if (keyEvent == KEY_DOWN2)
                fc = ConsoleColor.DarkGray;
            else if (keyEvent == KEY_UP)
                fc = ConsoleColor.Gray;
            else
                fc = ConsoleColor.Yellow;

            Console.ForegroundColor = fc;
        }

        void ChangeConsoleColor(int keyEvent, bool isAccept)
        {
            ConsoleColor fc;

            if (isAccept)
            {
                if (keyEvent == KEY_DOWN)
                    fc = ConsoleColor.Cyan;
                else if (keyEvent == KEY_DOWN2)
                    fc = ConsoleColor.DarkCyan;
                else if (keyEvent == KEY_UP)
                    fc = ConsoleColor.Green;
                else
                    fc = ConsoleColor.Yellow;
            }
            else
            {
                if (keyEvent == KEY_DOWN)
                    fc = ConsoleColor.Magenta;
                else if (keyEvent == KEY_DOWN2)
                    fc = ConsoleColor.DarkMagenta;
                else if (keyEvent == KEY_UP)
                    fc = ConsoleColor.Red;
                else
                    fc = ConsoleColor.DarkYellow;
            }

            Console.ForegroundColor = fc;
        }

        string GetEventStr(int keyEvent)
        {
            switch (keyEvent)
            {
                case KEY_DOWN:
                    return "\u25BC";
                case KEY_DOWN2:
                    return "\u25BD";
                case KEY_UP:
                    return "\u2191";
                default:
                    return keyEvent.ToString();
            }
        }

        string GetDownState()
        {
            return "L:{"
                + (downCountOfLShift > 0 ? "S" : "-")
                + (downCountOfLCtrl > 0 ? "C" : "-")
                + (downCountOfLAlt > 0 ? "A" : "-")
                + (downCountOfLWin > 0 ? "W" : "-")
                + "} R:{"
                + (downCountOfRCtrl > 0 ? "C" : "-")
                + (downCountOfRAlt > 0 ? "A" : "-")
                + (downCountOfRShift > 0 ? "S" : "-")
                + "}";
        }
    }
}
