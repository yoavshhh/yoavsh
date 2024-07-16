#ifndef _TENET_CORE_X86_64_H
#define _TENET_CORE_X86_64_H

#include <stdint.h>

const int MAGIC = 0x414D4440;

const int POINTER_SIZE = 8;

const char* IP = "RIP";
const char* SP = "RSP";

const char* REGISTERS[] = {
    "RAX",
    "RBX",
    "RCX",
    "RDX",
    "RBP",
    "RSP",
    "RSI",
    "RDI",
    "R8",
    "R9",
    "R10",
    "R11",
    "R12",
    "R13",
    "R14",
    "R15",
    "RIP"
};

#endif // _TENET_CORE_X86_64_H