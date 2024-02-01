/*
Configuration for the code below:

Connect portA to J1 Port of 4 Digit Seven Segment Module
Jumpers of portA are : 5V, pull down ( top one to left, other to right )

Connect portE to J2 Port of 4 Digit Seven Segment Module
Jumpers of portE are : 5V, pull down ( top one to left, other to right )


This code displays the cubes of the numbers from 1 to 21 on a 4-digit 7-segment display.
The display is connected to Port A and Port E of the microcontroller.
Port A is used to output the binary patterns for the digits, and Port E is used to select which digit is displayed.
The binary patterns for the digits are stored in the `binary_pattern` array.
The `main()` function loops forever, displaying the cubes of the numbers from 1 to 21.

*/


unsigned char binary_pattern[] = {
    /* 0 */ 0x3F,
    /* 1 */ 0x06,
    /* 2 */ 0x5B,
    /* 3 */ 0x4F,
    /* 4 */ 0x66,
    /* 5 */ 0x6D,
    /* 6 */ 0x7D,
    /* 7 */ 0x07,
    /* 8 */ 0x7F,
    /* 9 */ 0x6F,
};
unsigned char digitsArr[]= {0,0,0,0};
unsigned char indexCount, digit;
unsigned char value = 1;
unsigned int cube;
unsigned int x, y;

// This function displays a single digit on the seven segment display. The unit parameter is the digit to be displayed, while the pause parameter controls the duration of the display
void displayOneDigit(char unit, int pause) {
     for (x = 0; x < pause; x++){
         for (y = 0; y < pause; y++) {
             portA = binary_pattern[unit];
             portE = 0x01;
             Delay_ms(1);
         }
     }
}

void displayTwoDigit(char unit, char ten, int pause) {
     for (x = 0; x < pause; x++){
         for (y = 0; y < pause; y++) {
             portA = binary_pattern[unit];
             portE = 0x02;
             Delay_ms(1);

             portA = binary_pattern[ten];
             portE = 0x01;
             Delay_ms(1);
         }
     }
}

void displayThreeDigit(char unit, char ten, char hundred, int pause) {
     for (x = 0; x < pause; x++){
         for (y = 0; y < pause; y++) {
             portA = binary_pattern[unit];
             portE = 0x04;
             Delay_ms(1);

             portA = binary_pattern[ten];
             portE = 0x02;
             Delay_ms(1);

             portA = binary_pattern[hundred];
             portE = 0x01;
             Delay_ms(1);
         }
     }
}

void displayFourDigit(char unit, char ten, char hundred, char thousand, int pause) {
     for (x = 0; x < pause; x++){
         for (y = 0; y < pause; y++) {
             portA = binary_pattern[unit];
             portE = 0x08;
             Delay_ms(1);

             portA = binary_pattern[ten];
             portE = 0x04;
             Delay_ms(1);

             portA = binary_pattern[hundred];
             portE = 0x02;
             Delay_ms(1);

             portA = binary_pattern[thousand];
             portE = 0x01;
             Delay_ms(1);
         }
     }
}

// This function breaks the number into its individual digits. The number parameter is the number to be broken, while the digitsArr parameter is the array to store the digits
void breakIntoDigits(int number) {
      indexCount = 0;
      digit = 0;
      while(number) {
           digit = number % 10;
           digitsArr[indexCount] = digit;
           indexCount = indexCount + 1;
           number = number / 10;
      }
}

void main() {
    // Initialize the PIC
    AD1PCFG = 0xFFFF;      // Configure AN pins as digital I/O
    JTAGEN_bit = 0;        // Disable JTAG

    // Initialize Port A and Port E as outputs
    TRISA = 0x00;  //portA is output to D
    TRISE = 0X00;  //portE is output to AN

    while(1){
        // Calculate the cube of the value
        cube = value * value * value;
        // Break the cube into its individual digits
        breakIntoDigits(cube);
        // Display the digits on the seven segment display
        if (cube / 10 == 0) {  // is a one digit number
            displayOneDigit(digitsArr[0], 40);
        } else if (cube / 100 == 0){ // is a two digit number
        displayTwoDigit(digitsArr[0], digitsArr[1], 40);
        } else if (cube / 1000 == 0) { // is three digit number
        displayThreeDigit(digitsArr[0], digitsArr[1], digitsArr[2], 40);
        } else { // is four digit number
        displayFourDigit(digitsArr[0], digitsArr[1], digitsArr[2], digitsArr[3], 40);
        }

        value = value + 1;
        
        // Reset the value to 1 if it exceeds 21
        if (value > 21)
            value = 1;
    }
}