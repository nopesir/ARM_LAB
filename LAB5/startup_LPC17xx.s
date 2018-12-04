;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF


myArea_size		EQU		0x00000018
				
				AREA 	myArea, NOINIT, READWRITE
myArea_mem		SPACE	myArea_size
C_p

				AREA	A_B, READONLY
					
A_p 			DCD 0xAAAE3412,0xFAAE3412,0xABEF5542,0xAABE3402,3,-5,0,11,-5,12,4,-5

B_p				DCD	0xFFFE3412,0xBBAE3412,5,-1,0xFFEEA341,3,9,-7					



M     			EQU     4
N				EQU		3
P				EQU		2


                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Si scriva un programma in Assembly ARM in grado di moltiplicare    ;
; due matrici. La prima matrice ha N righe e M colonne. La seconda   ;
; matrice ha M righe e P colonne. La matrice risultato ha N righe    ;
; e P colonne. Tutte le matrici contengono numeri con segno espressi ;
; su una word. N, M, P sono costanti da definire con EQU.            ;
; Le prime due matrici sono definite come costanti in un�area di     ;
; memoria READONLY. La terza matrice deve essere allocata in un�area ;
; DATA READWRITE. Le somme intermedie devono essere calcolate su due ;
; word. Al termine di un prodotto riga*colonna, si controlla la word ;
; pi� significativa della somma parziale. In caso di overflow,       ;
; occorre memorizzare come risultato il massimo numero (positivo o   ;
; negativo, in base al tipo di overflow) esprimibile su una word.    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                
M_index			RN 0
N_index			RN 1
P_index			RN 2
A_index			RN 3
B_index			RN 4
C_index			RN 5


				MOV M_index, #M						; M value used to cycle
				MOV N_index, #N 					; N value used to cycle
				MOV P_index, #P 					; P value used to cycle
				
				LDR A_index, =A_p					; Pointer to the memory of matrix A
				LDR B_index, =B_p					; Pointer to the memory of matrix B
				LDR C_index, =C_p					; Pointer to the memory of matrix C (result)
				MOV r8, #0							; Reset r8
				MOV r9, #0							; Reset r9
				MOV r10, #0							; Reset r10
				MOV r11, P_index 					; P value used as a constant
				
loop												; Loop on the matrix M
				ADD M_index, #-1					; Decrement the M value
				LDR r6, [A_index], #4				; Take the 32bit integer from A, and post-increment at the second one
				
				LDR r7, [B_index]					; Take the 32bit integer from B
				ADD B_index, B_index, r11, LSL #2	; Increment the matrix B in order to retrieve the element on the same column
				
				SMULL r6, r7, r6, r7				; Multiply the two elements on 64bit
				
				ADDS r8, r8, r6						; Add on 64bit the LSB
				ADC r9, r9, r7						; And the the MSB
				
				CBZ M_index, change_row				; If the counter of the column is zero, change row
				B loop								; Else do another loop
				
repeat_row											; As it says
				TEQ r9, #0x00000000					; Check if the MSB is 0
				TEQNE r9, #0xFFFFFFFF				; Else check if the MSB is -1
				
				STREQ r8, [C_index], #4				; If it's 0, store the MSB (r8) to C_index, than increment the pointer
				ADDSNE r9, r9, #0					; Else update the special register r9 with the S
				
				LDRPL r8, =0x7FFFFFFF				; Since there's overflow, if r9 is positive, load that in r8
				LDRMI r8, =0x80000000				; Since there's overflow, if r9 is negative, load that in r8
				
				STRNE r8, [C_index], #4				; Store the r8 value and then increment
				
				MOV r8, #0							; Reset r8
				MOV r9, #0							; Reset r9
				
				LDR B_index, =B_p					; Reload the matrix B pointer in B_index
				ADD B_index, B_index, #4			; Increment it by one position
				LDR M_index, =M						; Reload the M counter
				LDR A_index, =A_p					; Reload the matrix A pointer in A_index
				ADD A_index, A_index, r10, LSL #4	; Increment the pointer to A_index by r10 positions (r10 has the number of rows of A passed)
				
				B loop								; Go to the loop

change_row											; As it says
				ADD P_index, #-1					; Decrement P value
				CMP P_index, #0						; Compare P with zero value
				BNE repeat_row						; If P is not zero, repeat the row
				MOV P_index, #P						; Reload P value
				ADD N_index, #-1					; Decrement the N index
				ADD r10, r10, #1					; Since N is decrement, increment r10
				LDR M_index, =M						; Reload M value
				LDR B_index, =B_p					; Reload the matrix B pointer in B_index
				
				TEQ r9, #0x00000000					; Check if the MSB is 0
				TEQNE r9, #0xFFFFFFFF				; Else check if the MSB is -1

				
				
				STREQ r8, [C_index], #4				; If it's 0, store the MSB (r8) to C_index, than increment the pointer
				ADDSNE r9, r9, #0					; Else update the special register r9 with the S
				
				LDRPL r8, =0x7FFFFFFF				; Since there's overflow, if r9 is positive, load that in r8
				LDRMI r8, =0x80000000				; Since there's overflow, if r9 is negative, load that in r8
				
				STRNE r8, [C_index], #4				; Store the r8 value and then increment the pointer
				
				MOV r8, #0							; Reset r8
				MOV r9, #0							; Reset r9
				CBZ N_index, stop					; If the rows are finished, STOP
				B loop								; Else go to the loop
				
			
stop B stop

                ENDP


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                ;IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR

                ALIGN

                ENDIF


                END
