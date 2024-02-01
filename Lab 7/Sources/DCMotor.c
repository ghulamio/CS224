/**
  This is a DC Motor Implementation for Lab 7 Part 2b

  The motor can be turned clockwise, counterclockwise, or stopped.
  The direction of the motor is controlled by the buttons on the board.
  The motor is connected to PortA, while the buttons are connected to PortE.

*/


void init() {
     LATA = 0x0000; // initially motor is off as this sets RA1 and RA2 to zero
                    // so Control1 = Control2 = 0
     LATE = 0x0000; // initialize inputs from the buttons to zero as this sets
                    // RE0 = RE1 = RB0 = RB1 = 0
}

void turnClockWise() {
          // Turn the motor clockwise
          PORTA = 0x0000;
          Delay_ms(100);
          PORTA = 0x0003;
          Delay_ms(1000);
}

void turnCounterClockWise() {
         // Turn the motor counter-clockwise
         PORTA = 0x0000;
         Delay_ms(100);
         PORTA = 0x0002;
         Delay_ms(1000);

}

void stop() {
     // Stop the motor
     PORTA = 0x0000;
}

void main() {
     // Set All Pins on PortB to Digital I/O
     AD1PCFG = 0xFFFF; // setting all pins to 1 sets them to Digital I/O
     DDPCON.JTAGEN = 0; // disable JTAG

     // Initialize PortA as an output port
     TRISA = 0x0000;

     // Initialize PortE as input port
     TRISE = 0xFFFF;

     // Initialize the motor to be off
     init();

     // Loop forever
     while(1) {
            // Check if the button is pressed
            if (portE != 0x0003)
               // Turn the motor in direction of the button pressed
               portA = portE << 1;
            else
                // Stop the motor
                portA = 0x0000;
     }
}