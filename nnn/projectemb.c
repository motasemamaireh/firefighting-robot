// Function declarations
void initialize(void);
void read_sensors(void);
void move_robot(void);
void stop_robot(void);
void activate_water_pump(void);
void trigger_ultrasonic(void);
unsigned int read_ultrasonic(void);


// Global variables
unsigned int flame_detected = 0; // Flag to indicate flame detection
unsigned int flame_position = 0; // 1: front, 2: left, 3: right, 4: back

void ATD_init_A0();
unsigned int ATD_read_A0();

// Main function
void main() {
    initialize();
    ATD_init_A0();
    while (1) {
        read_sensors();
        if (flame_detected==1) {
            move_robot();
            //read_ultrasonic();
            if(flame_detected==0) {
                stop_robot();
                activate_water_pump();
            }
            flame_detected = 0; // Reset flame detected flag
        }
    }
}
void ATD_init_A0(){
ADCON0=0x41; //ATD ON,DONT GO.CHANNEL 0 , fosc/16
ADCON1=0xCE;
}
unsigned int ATD_read_A0(){
ADCON0= ADCON0 | 0x04;//go
while (ADCON0 & 0x04);
return ((ADRESH<<8) | ADRESL);
}
// Initialization function
void initialize() {
    // Set RB0, RB1, RB2 as inputs for digital flame sensors
    TRISB = 0x0F;
    // Set RA0 as input for analog flame sensor
    TRISA = 0xFF;
    // Set RD0 (Echo) as input, RD1 (Trig) as output for ultrasonic sensor
    TRISD = 0b00000001;
    TRISD |= (1 << 1); // Set RD1 as output
    // Set RC0 and RC1 as outputs for relay control (water pump) and servo control
    TRISC = 0b00000000;
    PORTD=0x00;
    PORTC=0x00;




    // ADC configuration
    ADCON0 = 0x01; // Turn on the ADC module
    ADCON1 = 0x0E; // Configure RA0 as analog input
}

// Sensor reading function
void read_sensors() {
    // Read analog flame sensor on RA0
    unsigned int analog_value = ATD_read_A0(); // Read from channel 0 (RA0)
    if (analog_value > 512) { // Assuming a threshold value of 512 for flame detection
        flame_detected = 1;
        flame_position = 1; // Front
    }
    // Read digital flame sensors on RB0, RB1, RB2
    if (PORTB & 0b00000100) {
        flame_detected = 1;
        flame_position = 2; // Left
    }
    if (PORTB & 0b00000010) {
        flame_detected = 1;
        flame_position = 3; // Right
    }
    if (PORTB & 0b00000001) {
        flame_detected = 1;
        flame_position = 4; // Back
    }
}

// Move robot function
void move_robot() {
     PORTD=0x00;
     PORTC=0x00;
    // Move robot based on the position of the detected flame
    if (flame_position == 1) { // Front
        // Move forward using H-Bridge control

       PORTD=PORTD | 0b00100000;
       PORTD=PORTD | 0b00000100;
       PORTC=PORTC | 0b00010000;
       PORTC=PORTC | 0b00100000;
        //PORTDbits.RD5 = 1; // Rear right wheel forward
        //PORTDbits.RD2 = 1; // Rear left wheel forward
        //PORTCbits.RC4 = 1; // Front left wheel forward
        //PORTCbits.RC5 = 1; // Front right wheel forward




    } else if (flame_position == 2) { // Left
        // Turn right wheels to move towards the flame
        while( !(PORTB & 0b00001000) ){
        PORTD=PORTD | 0b00100000 ; // Rear right wheel forward
        PORTC=PORTC|0b00100000 ; // Front right wheel forward
        }
    } else if (flame_position == 3) { // Right
        // Turn left wheels to move towards the flame
        while( !(PORTB & 0b00001000) ){
        PORTD=PORTD|0b00000100 ; // Rear left wheel forward
        PORTC=PORTC |0b00010000 ; // Front left wheel forward
        }
    } else if (flame_position == 4) { // Back
        // Turn right wheels to move towards the flame
        while( !(PORTB & 0b00001000) ){
        PORTD=PORTD|0b00100000; // Rear right wheel forward
        PORTC=PORTC | 0b00100000 ; // Front right wheel forward
        }
    }
}

// Stop robot function
void stop_robot() {
    // Stop all motors
    PORTD=PORTD|0b00000000 ; // Rear right wheel stop
    PORTD=PORTD|0b00000000 ; // Rear left wheel stop
    PORTC=PORTC|0b00000000 ; // Front left wheel stop
    PORTC=PORTC|0b00000000 ; // Front right wheel stop
}

// Activate water pump function
void activate_water_pump() {
    // Activate water pump relay
    PORTC=PORTC|0b00000001;
}

// Trigger ultrasonic sensor
void trigger_ultrasonic() {
    // Trigger ultrasonic sensor
    PORTD=PORTD |0b00000010 ;
    delay_us(10); // 10 microsecond pulse
    PORTD=PORTD|0b00000000 ;
}

// Read ultrasonic sensor
unsigned int read_ultrasonic() {
    // Read ultrasonic sensor
    // Example: Read pulse duration from RD0
    unsigned int duration = 0;
    trigger_ultrasonic();
    while (!PORTD & 0b00000000); // Wait for echo to go high
    while (PORTD &0b00000000) { // Measure high time
        duration++;
        delay_us(1);
    }
    return duration;
}