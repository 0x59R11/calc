
### Simple MS-DOS calculator

## Features:
- [X] Unsigned integer 16 bits numbers (uint16)
- [X] Choice of input/result number format
- [X] Input number can be negative (start with '-')
- [ ] Negative result can be shown with '-'
- [X] Available 4 number systems (dec, hex, oct, bin)
- [X] Shows: sum, difference, multiplication, division, remainder of division


![](https://raw.githubusercontent.com/0x59R11/calc/main/images/dec_to_dec.png)

![](https://raw.githubusercontent.com/0x59R11/calc/main/images/hex_to_bin.png)

![](https://raw.githubusercontent.com/0x59R11/calc/main/images/oct_to_dec.png)


## Installation
1. Install & setup requires tools
2. Build .OBJ files
3. Link .OBJ files
4. Run CALC.EXE

### Tools:
- MASM611
- ML.EXE (masm translator)
- LINK.EXE (linker .OBJ files)

### Building:
Need to build 3 .asm files

**1. Manually**
```bat
ML.EXE /c calc\calc.asm
```

```bat
ML.EXE /c string\string.asm
```


```bat
ML.EXE /c convr\convr.asm
```
**2. Using .bat file**
```bat
BUILD.bat
```

### Linking:
Need to link 3 .OBJ files

**1. Manually**
```bat
LINK.EXE calc.obj string.obj convr.obj
```

**2. Using .bat file**
```bat
BLINK.bat
```

If you have any questions, please leave them [HERE](https://github.com/0x59R11/calc/issues)
