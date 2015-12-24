#include "Bounce2.h"

// Available button modes.
const int MODE_HOLD = 0;
const int MODE_TOGGLE = 1;

// These are the array positions.
const int SWITCH3 = 0;
const int SWITCH2 = 1;
const int SWITCH1 = 2;
const int BLUE_BUTTON = 3;
const int GREEN_BUTTON = 4;
const int ONOFF_SWITCH = 5;

// Array position indices.
const int PINID = 0;
const int STATE = 1;
const int JOYID = 2;
const int INVERT = 3;
const int MODE = 4;

// Invert/don't invert codes.
const int NO_INVERTSTATE = 0;
const int INVERTSTATE = 1;




// Total number of buttons that will be defined.
const int NUM_BUTTONS = 6;

// Define the buttons
int SWITCHES[NUM_BUTTONS][5] = {
	/* SWITCH3      */ {4, -1, 1, NO_INVERTSTATE, MODE_TOGGLE},
	/* SWITCH2      */ {5, -1, 2, NO_INVERTSTATE, MODE_TOGGLE},
	/* SWITCH1      */ {6, -1, 3, NO_INVERTSTATE, MODE_TOGGLE},
	/* BLUE_BUTTON  */ {7, -1, 4, INVERTSTATE, MODE_HOLD},
	/* GREEN_BUTTON */ {8, -1, 5, INVERTSTATE, MODE_HOLD},
	/* ONOFF_SWITCH */ {9, -1, 6, INVERTSTATE, MODE_HOLD},
};

// An array to hold all the debouncers for the buttons.
Bounce DEBOUNCERS[NUM_BUTTONS];

// An array to hold the button names. Used for Serial debugging.
const char* NAMES[] = {
	"Switch 3",
	"Switch 2",
	"Switch 1",
	"Blue",
	"Green",
	"On/Off",
};

void setup() {
	Serial.begin(9600);
	Serial.println("Elite Button Box starting up...");

	int i;
	for (i = 0; i < NUM_BUTTONS; i = i + 1) {

		// Setup the pin configuration
		pinMode(SWITCHES[i][PINID], INPUT_PULLUP);
		
		// Setup the debouncer for each pin
		DEBOUNCERS[i] = Bounce();
		DEBOUNCERS[i].attach(SWITCHES[i][PINID]);
		DEBOUNCERS[i].interval(5);
		
		updateButton(i);
	}  
	printButtonStates();

	Serial.println("Start up complete.");
}


int last_print = 0;
void loop() {
	
	int i;
	for (i = 0; i < NUM_BUTTONS; i = i + 1) {
		updateButton(i);
	}
	
	if ((millis() - last_print) > 5000) {
		//printButtonStates();
		last_print = millis();
	}
}

void printButtonStates() {
	int i;
	for (i = 0; i < NUM_BUTTONS; i = i + 1) {
		Serial.print(i);
		Serial.print(":");
		Serial.print(NAMES[i]);
		Serial.print(":");
		Serial.print(SWITCHES[i][STATE]);
		Serial.print(" ");
	}	
	Serial.println();
}

void updateButton(int button) {
	
	// Get the current button state from the debouncer
	DEBOUNCERS[button].update();
	int state = DEBOUNCERS[button].read();
	
	// If this button is flagged as being wired up 'backwards', invert the signal.
	if (SWITCHES[button][INVERT] == INVERTSTATE) {
		state = !state;
	}
	
	// If the state of the button has changed, update it.
	if (SWITCHES[button][STATE] != state) {
		SWITCHES[button][STATE] = state;
		
		Serial.print("Button changed:");
		Serial.println(NAMES[button]);
		
		// Different switches can have different modes of operation.
		switch (SWITCHES[button][MODE]) {
			
			// HOLD buttons behave just like you'd expect a pushbutton on a joystick to behave.
			case MODE_HOLD:
				Joystick.button(SWITCHES[button][JOYID], state);
				break;
				
			// TOGGLE buttons look like two-position switches, but in reality behave like HOLD
			// buttons do. Switching them is the same as pressing and releasing a button.
			case MODE_TOGGLE:
				Joystick.button(SWITCHES[button][JOYID], HIGH);
				delay(200);
				Joystick.button(SWITCHES[button][JOYID], LOW);
				break;
			
		}
	}
}
