HexToFloat(value) {																			;-- Hexadecimal to Float conversion
    Return, (1 - 2 * (value >> 31)) * (2 ** ((value >> 23 & 255) - 150)) * (0x800000 | value & 0x7FFFFF)
}