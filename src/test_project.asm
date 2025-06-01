;-------------------------------------------------------------------------------;
;Title:Waste managment microprocessor project                                   ;
;Author: Mohamed Wael 221029                                                    ;
;Description: the aim of this program is to sor meatl waste from general waste  ;
;-------------------------------------------------------------------------------;


LIST P=16F877A
#include <P16F877A.INC>

; Configuration Bits
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC & _BODEN_ON & _LVP_OFF

; Variables
COUNT1       EQU 0x20  
COUNT2       EQU 0x21
COUNT3       EQU 0x22
ADC_RESULT_H EQU 0x23
ADC_RESULT_L EQU 0x24
TEMP         EQU 0x25
NIBBLE       EQU 0x26
SERVO_STATE  EQU 0x27

; Constants
ADC_THRESHOLD_H EQU 0x02
ADC_THRESHOLD_L EQU 0x00

ORG 0x00
GOTO INIT
ORG 0x04
    BCF INTCON, 1
int_loop:
    CALL LED_ON
    BTFSC PORTB,0
    GOTO int_loop
    CALL LED_OFF
RETFIE




;-------------------------
; Delay Subroutines
;-------------------------
DELAY_1S:
    MOVLW D'20'
    MOVWF COUNT1
DELAY_1S_LOOP:
    MOVLW D'250'
    MOVWF COUNT2
DELAY_MS_LOOP:
    MOVLW D'250'
    MOVWF COUNT3
DELAY_US_LOOP:
    NOP
    DECFSZ COUNT3, F
    GOTO DELAY_US_LOOP
    DECFSZ COUNT2, F
    GOTO DELAY_MS_LOOP
    DECFSZ COUNT1, F
    GOTO DELAY_1S_LOOP
    RETURN

DELAY_50MS:
    MOVLW D'200'
    MOVWF COUNT1
DELAY_50MS_1:
    MOVLW D'250'
    MOVWF COUNT2
DELAY_50MS_2:
    NOP
    DECFSZ COUNT2,F
    GOTO DELAY_50MS_2
    DECFSZ COUNT1,F
    GOTO DELAY_50MS_1
    RETURN

DELAY_5MS:
    MOVLW D'20'
    MOVWF COUNT1
DELAY_5MS_1:
    MOVLW D'250'
    MOVWF COUNT2
DELAY_5MS_2:
    NOP
    DECFSZ COUNT2,F
    GOTO DELAY_5MS_2
    DECFSZ COUNT1,F
    GOTO DELAY_5MS_1
    RETURN

DELAY_1MS:
    MOVLW D'4'
    MOVWF COUNT1
DELAY_1MS_1:
    MOVLW D'250'
    MOVWF COUNT2
DELAY_1MS_2:
    NOP
    DECFSZ COUNT2,F
    GOTO DELAY_1MS_2
    DECFSZ COUNT1,F
    GOTO DELAY_1MS_1
    RETURN

DELAY_2MS:
    MOVLW D'8'
    MOVWF COUNT1
DELAY_2MS_1:
    MOVLW D'250'
    MOVWF COUNT2
DELAY_2MS_2:
    NOP
    DECFSZ COUNT2,F
    GOTO DELAY_2MS_2
    DECFSZ COUNT1,F
    GOTO DELAY_2MS_1
    RETURN

DELAY_20US:
    MOVLW D'20'
    MOVWF COUNT3
DELAY_20US_LOOP:
    NOP
    DECFSZ COUNT3, F
    GOTO DELAY_20US_LOOP
    RETURN

;-------------------------
; LCD Subroutines (Direct Port Access)
;-------------------------
LCD_INIT:
    ; Initialization sequence
    MOVLW 0x03
    CALL LCD_NIBBLE
    CALL DELAY_5MS
    
    MOVLW 0x03
    CALL LCD_NIBBLE
    CALL DELAY_1MS
    
    MOVLW 0x03
    CALL LCD_NIBBLE
    CALL DELAY_1MS
    
    ; Switch to 4-bit mode
    MOVLW 0x02
    CALL LCD_NIBBLE
    CALL DELAY_1MS
    
    ; Function Set: 4-bit, 2-line, 5x8 dots
    MOVLW 0x28
    CALL LCD_CMD
    
    ; Display ON, Cursor OFF, Blink OFF
    MOVLW 0x0C
    CALL LCD_CMD
    
    ; Clear Display
    MOVLW 0x01
    CALL LCD_CMD
    CALL DELAY_2MS
    
    ; Entry Mode Set: Increment, no shift
    MOVLW 0x06
    CALL LCD_CMD
    RETURN

LCD_CMD:
    BCF PORTD,5       ; RS=0 (Command)
    GOTO LCD_SEND

LCD_DATA:
    BSF PORTD,5       ; RS=1 (Data)

LCD_SEND:
    MOVWF TEMP
    SWAPF TEMP,W
    CALL LCD_NIBBLE
    MOVF TEMP,W
    CALL LCD_NIBBLE
    MOVLW 0x02
    MOVWF COUNT1
LCD_DELAY:
    DECFSZ COUNT1,F
    GOTO LCD_DELAY
    RETURN

LCD_NIBBLE:
    ANDLW 0x0F
    MOVWF NIBBLE
    BANKSEL PORTC
    
    BCF PORTC,4       ; D4
    BTFSC NIBBLE,0
    BSF PORTC,4
    
    BCF PORTC,5       ; D5
    BTFSC NIBBLE,1
    BSF PORTC,5
    
    BCF PORTC,6       ; D6
    BTFSC NIBBLE,2
    BSF PORTC,6
    
    BCF PORTC,7       ; D7
    BTFSC NIBBLE,3
    BSF PORTC,7
    
    BSF PORTD,7       ; E=1
    NOP
    NOP
    BCF PORTD,7       ; E=0
    RETURN

LCD_CLEAR:
    MOVLW 0x01
    CALL LCD_CMD
    CALL DELAY_2MS
    RETURN

;-------------------------
; Display Strings
;-------------------------
DISPLAY_METAL:
    CALL LCD_CLEAR
    MOVLW 0x80
    CALL LCD_CMD
    
    MOVLW 'M'
    CALL LCD_DATA
    MOVLW 'E'
    CALL LCD_DATA
    MOVLW 'T'
    CALL LCD_DATA
    MOVLW 'A'
    CALL LCD_DATA
    MOVLW 'L'
    CALL LCD_DATA
    RETURN

DISPLAY_PLASTIC:
    CALL LCD_CLEAR
    MOVLW 0x80
    CALL LCD_CMD
    
    MOVLW 'P'
    CALL LCD_DATA
    MOVLW 'L'
    CALL LCD_DATA
    MOVLW 'A'
    CALL LCD_DATA
    MOVLW 'S'
    CALL LCD_DATA
    MOVLW 'T'
    CALL LCD_DATA
    MOVLW 'I'
    CALL LCD_DATA
    MOVLW 'C'
    CALL LCD_DATA
    RETURN

DISPLAY_NO_OBJECT:
    MOVLW 0x80
    CALL LCD_CMD
    
    MOVLW 'N'
    CALL LCD_DATA
    MOVLW 'O'
    CALL LCD_DATA
    MOVLW ' '
    CALL LCD_DATA
    MOVLW 'O'
    CALL LCD_DATA
    MOVLW 'B'
    CALL LCD_DATA
    MOVLW 'J'
    CALL LCD_DATA
    MOVLW 'E'
    CALL LCD_DATA
    MOVLW 'C'
    CALL LCD_DATA
    MOVLW 'T'
    CALL LCD_DATA
    RETURN

;-------------------------
; ADC Functions
;-------------------------
READ_ADC:
    BANKSEL ADCON0
    MOVLW B'01000001'
    MOVWF ADCON0
    CALL DELAY_20US
    
    BSF ADCON0, GO
ADC_WAIT:
    BTFSC ADCON0, GO
    GOTO ADC_WAIT
    
    BANKSEL ADRESH
    MOVF ADRESH, W
    MOVWF ADC_RESULT_H
    MOVF ADRESL, W
    MOVWF ADC_RESULT_L
    RETURN

CHECK_THRESHOLD:
    MOVF ADC_RESULT_H, W
    SUBLW ADC_THRESHOLD_H
    BTFSS STATUS, C
    GOTO LED_ON
    BTFSS STATUS, Z
    GOTO LED_OFF
    
    MOVF ADC_RESULT_L, W
    SUBLW ADC_THRESHOLD_L
    BTFSS STATUS, C
    GOTO LED_ON
    GOTO LED_OFF

LED_OFF:
    BANKSEL PORTD
    BCF PORTD, 3
    RETURN

LED_ON:
    BANKSEL PORTD
    BSF PORTD, 3
    RETURN

;-------------------------
; Servo Position Functions
;-------------------------
SERVO_0:
    BANKSEL CCPR1L
    MOVLW D'50'
    MOVWF CCPR1L
    MOVLW 0
    MOVWF SERVO_STATE
    CALL DISPLAY_PLASTIC
    CALL DELAY_1S
    RETURN

SERVO_90:
    BANKSEL CCPR1L
    MOVLW .94
    MOVWF CCPR1L
    MOVLW 1
    MOVWF SERVO_STATE
    CALL DISPLAY_NO_OBJECT
    RETURN

SERVO_180:
    BANKSEL CCPR1L
    MOVLW .140
    MOVWF CCPR1L
    MOVLW 2
    MOVWF SERVO_STATE
    CALL DISPLAY_METAL
    CALL DELAY_1S
    RETURN

CHECK_B2:
    BTFSS PORTB,2
    CALL SERVO_180
    CALL SERVO_0
    RETURN

;-------------------------
; Initialization
;-------------------------
INIT:
    BSF INTCON, 7
    BSF INTCON, 4
	

    BANKSEL TRISD
    CLRF TRISD
    CLRF TRISC
    BANKSEL PORTD
    CLRF PORTD
    CLRF PORTC
    
    ; Ground RW pin
    BCF PORTD,6
    
    ; Extended power-up delay
    CALL DELAY_50MS
    CALL DELAY_50MS
    
    ; Initialize LCD
    CALL LCD_INIT
    CALL LCD_CLEAR
    
    ; PWM Setup
    BANKSEL TRISC
    BCF TRISC, 2
    BSF TRISC, 0
    BSF TRISC, 1

    ; PORTD setup - RD3 as output for LED
    BCF TRISD, 3
    BANKSEL PORTD
    BCF PORTD, 3

    ; ADC Setup
    BANKSEL ADCON1
    MOVLW B'10000000'
    MOVWF ADCON1

    ; PWM Configuration
    BANKSEL PR2
    MOVLW .249
    MOVWF PR2

    BANKSEL CCP1CON
    MOVLW B'00001100'
    MOVWF CCP1CON

    BANKSEL T2CON
    MOVLW B'00000111'
    MOVWF T2CON

    ; Initialize servo to 90°
    CALL SERVO_90

;-------------------------
; Main Program Loop
;-------------------------
MAIN_LOOP:
    CALL READ_ADC
    CALL CHECK_THRESHOLD
    
    BTFSS PORTB,2
    CALL SERVO_180

    BTFSS PORTB,1
    CALL CHECK_B2
    
    CALL SERVO_90
 	CALL DELAY_1S
    
    
    GOTO MAIN_LOOP

END