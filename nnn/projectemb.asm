
_main:

;projectemb.c,19 :: 		void main() {
;projectemb.c,20 :: 		initialize();
	CALL       _initialize+0
;projectemb.c,21 :: 		ATD_init_A0();
	CALL       _ATD_init_A0+0
;projectemb.c,22 :: 		while (1) {
L_main0:
;projectemb.c,23 :: 		read_sensors();
	CALL       _read_sensors+0
;projectemb.c,24 :: 		if (flame_detected==1) {
	MOVLW      0
	XORWF      _flame_detected+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main29
	MOVLW      1
	XORWF      _flame_detected+0, 0
L__main29:
	BTFSS      STATUS+0, 2
	GOTO       L_main2
;projectemb.c,25 :: 		move_robot();
	CALL       _move_robot+0
;projectemb.c,27 :: 		if(flame_detected==0) {
	MOVLW      0
	XORWF      _flame_detected+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main30
	MOVLW      0
	XORWF      _flame_detected+0, 0
L__main30:
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;projectemb.c,28 :: 		stop_robot();
	CALL       _stop_robot+0
;projectemb.c,29 :: 		activate_water_pump();
	CALL       _activate_water_pump+0
;projectemb.c,30 :: 		}
L_main3:
;projectemb.c,31 :: 		flame_detected = 0; // Reset flame detected flag
	CLRF       _flame_detected+0
	CLRF       _flame_detected+1
;projectemb.c,32 :: 		}
L_main2:
;projectemb.c,33 :: 		}
	GOTO       L_main0
;projectemb.c,34 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ATD_init_A0:

;projectemb.c,35 :: 		void ATD_init_A0(){
;projectemb.c,36 :: 		ADCON0=0x41; //ATD ON,DONT GO.CHANNEL 0 , fosc/16
	MOVLW      65
	MOVWF      ADCON0+0
;projectemb.c,37 :: 		ADCON1=0xCE;
	MOVLW      206
	MOVWF      ADCON1+0
;projectemb.c,38 :: 		}
L_end_ATD_init_A0:
	RETURN
; end of _ATD_init_A0

_ATD_read_A0:

;projectemb.c,39 :: 		unsigned int ATD_read_A0(){
;projectemb.c,40 :: 		ADCON0= ADCON0 | 0x04;//go
	BSF        ADCON0+0, 2
;projectemb.c,41 :: 		while (ADCON0 & 0x04);
L_ATD_read_A04:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read_A05
	GOTO       L_ATD_read_A04
L_ATD_read_A05:
;projectemb.c,42 :: 		return ((ADRESH<<8) | ADRESL);
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;projectemb.c,43 :: 		}
L_end_ATD_read_A0:
	RETURN
; end of _ATD_read_A0

_initialize:

;projectemb.c,45 :: 		void initialize() {
;projectemb.c,47 :: 		TRISB = 0x0F;
	MOVLW      15
	MOVWF      TRISB+0
;projectemb.c,49 :: 		TRISA = 0xFF;
	MOVLW      255
	MOVWF      TRISA+0
;projectemb.c,51 :: 		TRISD = 0b00000001;
	MOVLW      1
	MOVWF      TRISD+0
;projectemb.c,52 :: 		TRISD |= (1 << 1); // Set RD1 as output
	BSF        TRISD+0, 1
;projectemb.c,54 :: 		TRISC = 0b00000000;
	CLRF       TRISC+0
;projectemb.c,55 :: 		PORTD=0x00;
	CLRF       PORTD+0
;projectemb.c,56 :: 		PORTC=0x00;
	CLRF       PORTC+0
;projectemb.c,62 :: 		ADCON0 = 0x01; // Turn on the ADC module
	MOVLW      1
	MOVWF      ADCON0+0
;projectemb.c,63 :: 		ADCON1 = 0x0E; // Configure RA0 as analog input
	MOVLW      14
	MOVWF      ADCON1+0
;projectemb.c,64 :: 		}
L_end_initialize:
	RETURN
; end of _initialize

_read_sensors:

;projectemb.c,67 :: 		void read_sensors() {
;projectemb.c,69 :: 		unsigned int analog_value = ATD_read_A0(); // Read from channel 0 (RA0)
	CALL       _ATD_read_A0+0
;projectemb.c,70 :: 		if (analog_value > 512) { // Assuming a threshold value of 512 for flame detection
	MOVF       R0+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__read_sensors35
	MOVF       R0+0, 0
	SUBLW      0
L__read_sensors35:
	BTFSC      STATUS+0, 0
	GOTO       L_read_sensors6
;projectemb.c,71 :: 		flame_detected = 1;
	MOVLW      1
	MOVWF      _flame_detected+0
	MOVLW      0
	MOVWF      _flame_detected+1
;projectemb.c,72 :: 		flame_position = 1; // Front
	MOVLW      1
	MOVWF      _flame_position+0
	MOVLW      0
	MOVWF      _flame_position+1
;projectemb.c,73 :: 		}
L_read_sensors6:
;projectemb.c,75 :: 		if (PORTB & 0b00000100) {
	BTFSS      PORTB+0, 2
	GOTO       L_read_sensors7
;projectemb.c,76 :: 		flame_detected = 1;
	MOVLW      1
	MOVWF      _flame_detected+0
	MOVLW      0
	MOVWF      _flame_detected+1
;projectemb.c,77 :: 		flame_position = 2; // Left
	MOVLW      2
	MOVWF      _flame_position+0
	MOVLW      0
	MOVWF      _flame_position+1
;projectemb.c,78 :: 		}
L_read_sensors7:
;projectemb.c,79 :: 		if (PORTB & 0b00000010) {
	BTFSS      PORTB+0, 1
	GOTO       L_read_sensors8
;projectemb.c,80 :: 		flame_detected = 1;
	MOVLW      1
	MOVWF      _flame_detected+0
	MOVLW      0
	MOVWF      _flame_detected+1
;projectemb.c,81 :: 		flame_position = 3; // Right
	MOVLW      3
	MOVWF      _flame_position+0
	MOVLW      0
	MOVWF      _flame_position+1
;projectemb.c,82 :: 		}
L_read_sensors8:
;projectemb.c,83 :: 		if (PORTB & 0b00000001) {
	BTFSS      PORTB+0, 0
	GOTO       L_read_sensors9
;projectemb.c,84 :: 		flame_detected = 1;
	MOVLW      1
	MOVWF      _flame_detected+0
	MOVLW      0
	MOVWF      _flame_detected+1
;projectemb.c,85 :: 		flame_position = 4; // Back
	MOVLW      4
	MOVWF      _flame_position+0
	MOVLW      0
	MOVWF      _flame_position+1
;projectemb.c,86 :: 		}
L_read_sensors9:
;projectemb.c,87 :: 		}
L_end_read_sensors:
	RETURN
; end of _read_sensors

_move_robot:

;projectemb.c,90 :: 		void move_robot() {
;projectemb.c,91 :: 		PORTD=0x00;
	CLRF       PORTD+0
;projectemb.c,92 :: 		PORTC=0x00;
	CLRF       PORTC+0
;projectemb.c,94 :: 		if (flame_position == 1) { // Front
	MOVLW      0
	XORWF      _flame_position+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__move_robot37
	MOVLW      1
	XORWF      _flame_position+0, 0
L__move_robot37:
	BTFSS      STATUS+0, 2
	GOTO       L_move_robot10
;projectemb.c,97 :: 		PORTD=PORTD | 0b00100000;
	BSF        PORTD+0, 5
;projectemb.c,98 :: 		PORTD=PORTD | 0b00000100;
	BSF        PORTD+0, 2
;projectemb.c,99 :: 		PORTC=PORTC | 0b00010000;
	BSF        PORTC+0, 4
;projectemb.c,100 :: 		PORTC=PORTC | 0b00100000;
	BSF        PORTC+0, 5
;projectemb.c,109 :: 		} else if (flame_position == 2) { // Left
	GOTO       L_move_robot11
L_move_robot10:
	MOVLW      0
	XORWF      _flame_position+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__move_robot38
	MOVLW      2
	XORWF      _flame_position+0, 0
L__move_robot38:
	BTFSS      STATUS+0, 2
	GOTO       L_move_robot12
;projectemb.c,111 :: 		while( !(PORTB & 0b00001000) ){
L_move_robot13:
	BTFSC      PORTB+0, 3
	GOTO       L_move_robot14
;projectemb.c,112 :: 		PORTD=PORTD | 0b00100000 ; // Rear right wheel forward
	BSF        PORTD+0, 5
;projectemb.c,113 :: 		PORTC=PORTC|0b00100000 ; // Front right wheel forward
	BSF        PORTC+0, 5
;projectemb.c,114 :: 		}
	GOTO       L_move_robot13
L_move_robot14:
;projectemb.c,115 :: 		} else if (flame_position == 3) { // Right
	GOTO       L_move_robot15
L_move_robot12:
	MOVLW      0
	XORWF      _flame_position+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__move_robot39
	MOVLW      3
	XORWF      _flame_position+0, 0
L__move_robot39:
	BTFSS      STATUS+0, 2
	GOTO       L_move_robot16
;projectemb.c,117 :: 		while( !(PORTB & 0b00001000) ){
L_move_robot17:
	BTFSC      PORTB+0, 3
	GOTO       L_move_robot18
;projectemb.c,118 :: 		PORTD=PORTD|0b00000100 ; // Rear left wheel forward
	BSF        PORTD+0, 2
;projectemb.c,119 :: 		PORTC=PORTC |0b00010000 ; // Front left wheel forward
	BSF        PORTC+0, 4
;projectemb.c,120 :: 		}
	GOTO       L_move_robot17
L_move_robot18:
;projectemb.c,121 :: 		} else if (flame_position == 4) { // Back
	GOTO       L_move_robot19
L_move_robot16:
	MOVLW      0
	XORWF      _flame_position+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__move_robot40
	MOVLW      4
	XORWF      _flame_position+0, 0
L__move_robot40:
	BTFSS      STATUS+0, 2
	GOTO       L_move_robot20
;projectemb.c,123 :: 		while( !(PORTB & 0b00001000) ){
L_move_robot21:
	BTFSC      PORTB+0, 3
	GOTO       L_move_robot22
;projectemb.c,124 :: 		PORTD=PORTD|0b00100000; // Rear right wheel forward
	BSF        PORTD+0, 5
;projectemb.c,125 :: 		PORTC=PORTC | 0b00100000 ; // Front right wheel forward
	BSF        PORTC+0, 5
;projectemb.c,126 :: 		}
	GOTO       L_move_robot21
L_move_robot22:
;projectemb.c,127 :: 		}
L_move_robot20:
L_move_robot19:
L_move_robot15:
L_move_robot11:
;projectemb.c,128 :: 		}
L_end_move_robot:
	RETURN
; end of _move_robot

_stop_robot:

;projectemb.c,131 :: 		void stop_robot() {
;projectemb.c,133 :: 		PORTD=PORTD|0b00000000 ; // Rear right wheel stop
;projectemb.c,134 :: 		PORTD=PORTD|0b00000000 ; // Rear left wheel stop
;projectemb.c,135 :: 		PORTC=PORTC|0b00000000 ; // Front left wheel stop
;projectemb.c,136 :: 		PORTC=PORTC|0b00000000 ; // Front right wheel stop
;projectemb.c,137 :: 		}
L_end_stop_robot:
	RETURN
; end of _stop_robot

_activate_water_pump:

;projectemb.c,140 :: 		void activate_water_pump() {
;projectemb.c,142 :: 		PORTC=PORTC|0b00000001;
	BSF        PORTC+0, 0
;projectemb.c,143 :: 		}
L_end_activate_water_pump:
	RETURN
; end of _activate_water_pump

_trigger_ultrasonic:

;projectemb.c,146 :: 		void trigger_ultrasonic() {
;projectemb.c,148 :: 		PORTD=PORTD |0b00000010 ;
	BSF        PORTD+0, 1
;projectemb.c,149 :: 		delay_us(10); // 10 microsecond pulse
	MOVLW      6
	MOVWF      R13+0
L_trigger_ultrasonic23:
	DECFSZ     R13+0, 1
	GOTO       L_trigger_ultrasonic23
	NOP
;projectemb.c,150 :: 		PORTD=PORTD|0b00000000 ;
;projectemb.c,151 :: 		}
L_end_trigger_ultrasonic:
	RETURN
; end of _trigger_ultrasonic

_read_ultrasonic:

;projectemb.c,154 :: 		unsigned int read_ultrasonic() {
;projectemb.c,157 :: 		unsigned int duration = 0;
	CLRF       read_ultrasonic_duration_L0+0
	CLRF       read_ultrasonic_duration_L0+1
;projectemb.c,158 :: 		trigger_ultrasonic();
	CALL       _trigger_ultrasonic+0
;projectemb.c,159 :: 		while (!PORTD & 0b00000000); // Wait for echo to go high
L_read_ultrasonic24:
	MOVF       PORTD+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	ANDWF      R0+0, 1
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_ultrasonic25
	GOTO       L_read_ultrasonic24
L_read_ultrasonic25:
;projectemb.c,160 :: 		while (PORTD &0b00000000) { // Measure high time
L_read_ultrasonic26:
	MOVLW      0
	ANDWF      PORTD+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_read_ultrasonic27
;projectemb.c,161 :: 		duration++;
	INCF       read_ultrasonic_duration_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       read_ultrasonic_duration_L0+1, 1
;projectemb.c,162 :: 		delay_us(1);
	NOP
	NOP
;projectemb.c,163 :: 		}
	GOTO       L_read_ultrasonic26
L_read_ultrasonic27:
;projectemb.c,164 :: 		return duration;
	MOVF       read_ultrasonic_duration_L0+0, 0
	MOVWF      R0+0
	MOVF       read_ultrasonic_duration_L0+1, 0
	MOVWF      R0+1
;projectemb.c,165 :: 		}
L_end_read_ultrasonic:
	RETURN
; end of _read_ultrasonic
