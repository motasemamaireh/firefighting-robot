#line 1 "C:/Users/20190430/Desktop/nnn/projectemb.c"

void initialize(void);
void read_sensors(void);
void move_robot(void);
void stop_robot(void);
void activate_water_pump(void);
void trigger_ultrasonic(void);
unsigned int read_ultrasonic(void);



unsigned int flame_detected = 0;
unsigned int flame_position = 0;

void ATD_init_A0();
unsigned int ATD_read_A0();


void main() {
 initialize();
 ATD_init_A0();
 while (1) {
 read_sensors();
 if (flame_detected==1) {
 move_robot();

 if(flame_detected==0) {
 stop_robot();
 activate_water_pump();
 }
 flame_detected = 0;
 }
 }
}
void ATD_init_A0(){
ADCON0=0x41;
ADCON1=0xCE;
}
unsigned int ATD_read_A0(){
ADCON0= ADCON0 | 0x04;
while (ADCON0 & 0x04);
return ((ADRESH<<8) | ADRESL);
}

void initialize() {

 TRISB = 0x0F;

 TRISA = 0xFF;

 TRISD = 0b00000001;
 TRISD |= (1 << 1);

 TRISC = 0b00000000;
 PORTD=0x00;
 PORTC=0x00;





 ADCON0 = 0x01;
 ADCON1 = 0x0E;
}


void read_sensors() {

 unsigned int analog_value = ATD_read_A0();
 if (analog_value > 512) {
 flame_detected = 1;
 flame_position = 1;
 }

 if (PORTB & 0b00000100) {
 flame_detected = 1;
 flame_position = 2;
 }
 if (PORTB & 0b00000010) {
 flame_detected = 1;
 flame_position = 3;
 }
 if (PORTB & 0b00000001) {
 flame_detected = 1;
 flame_position = 4;
 }
}


void move_robot() {
 PORTD=0x00;
 PORTC=0x00;

 if (flame_position == 1) {


 PORTD=PORTD | 0b00100000;
 PORTD=PORTD | 0b00000100;
 PORTC=PORTC | 0b00010000;
 PORTC=PORTC | 0b00100000;








 } else if (flame_position == 2) {

 while( !(PORTB & 0b00001000) ){
 PORTD=PORTD | 0b00100000 ;
 PORTC=PORTC|0b00100000 ;
 }
 } else if (flame_position == 3) {

 while( !(PORTB & 0b00001000) ){
 PORTD=PORTD|0b00000100 ;
 PORTC=PORTC |0b00010000 ;
 }
 } else if (flame_position == 4) {

 while( !(PORTB & 0b00001000) ){
 PORTD=PORTD|0b00100000;
 PORTC=PORTC | 0b00100000 ;
 }
 }
}


void stop_robot() {

 PORTD=PORTD|0b00000000 ;
 PORTD=PORTD|0b00000000 ;
 PORTC=PORTC|0b00000000 ;
 PORTC=PORTC|0b00000000 ;
}


void activate_water_pump() {

 PORTC=PORTC|0b00000001;
}


void trigger_ultrasonic() {

 PORTD=PORTD |0b00000010 ;
 delay_us(10);
 PORTD=PORTD|0b00000000 ;
}


unsigned int read_ultrasonic() {


 unsigned int duration = 0;
 trigger_ultrasonic();
 while (!PORTD & 0b00000000);
 while (PORTD &0b00000000) {
 duration++;
 delay_us(1);
 }
 return duration;
}
