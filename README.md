# NSYSU_Assembly
2023 fall semester

Some homework solutions with my understanding and absorb other people concept.

## HW Descriptions

### Prog1: 字母轉換 (Letter Conversion)
這是一個 **ARM** 組合語言程式。它會讀取一個命令列參數（command-line argument）字串，然後遍歷這個字串。程式會過濾掉所有非英文字母的字元，並將所有大寫字母（A-Z）轉換為小寫字母（a-z）後，將結果印到標準輸出。

### Prog2: 簡易 ARM 反組合器 (Simple ARM Disassembler)
這是一個 **ARM** 組合語言程式，其功能為一個簡易的反組合器。它會讀取一段內嵌（透過 `.include`）的 ARM 機器碼，逐一分析每條 32-bit 指令，然後印出該指令的：
1.  **PC (Program Counter)** 值。
2.  **Condition Code** (條件碼)，例如 `EQ`, `NE`, `AL` 等。
3.  **Instruction Type** (指令類型)，例如 `MOV`, `ADD`, `LDR`, `STR`, `B` (Branch) 等。如果無法識別，則印出 `UND` (Undefined)。

### Prog3: 數值運算 (Numerical Operations)
這是一個 **x86** 組合語言程式（使用 NASM 語法，針對 Linux 系統呼叫 `int 0x80`）。程式會從標準輸入（stdin）讀取三個以空白分隔的整數（num1, num2, opcode）。根據 opcode 的值，程式會執行三種不同功能之一：
* **Opcode 1**: 找出 num1 和 num2 中的**最大值**。
* **Opcode 2**: 計算 num1 和 num2 的**最大公因數 (GCD)**。
* **Opcode 3**: 計算 num1 和 num2 的**最小公倍數 (LCM)**。

程式最後會將運算結果以格式化的英文字串（例如 "Function 1: maximum of 10 and 20 is 20."）印出。
