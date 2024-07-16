#ifndef _TENET_CORE_X86_32_H
#define _TENET_CORE_X86_32_H

#include <stdint.h>

const int MAGIC = 0x386;

const int POINTER_SIZE = 4;

const char* IP = "EIP";
const char* SP = "ESP";

const char* REGISTERS[] = {
    "EAX",
    "EBX",
    "ECX",
    "EDX",
    "EBP",
    "ESP",
    "ESI",
    "EDI",
    "EIP"
};

#endif // _TENET_CORE_X86_32_H