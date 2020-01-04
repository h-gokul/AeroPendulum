

//initialise Pins for Accelerometers --> feedback sensors
const int xPin = A0;
const int yPin = A1;
const int zPin = A2;

// to model and normalise the data input
int minVal = 286;
int maxVal = 435;
int p[2];

// P,I, D constants
double Kp = 0.01;
double Ki = 0.000;
double Kd = 0.00;

// initialising variables to be used
double sat = 0;
double x;
double y;
double z;
int xAng;
int yAng;
int zAng;
int SETANGLE = 10;
float previ = 0;
float i = 0;
float int_error = 0;
float w = 0.7;

void setup()
{
  Serial.begin(9600);
  pinMode(10, OUTPUT);
  digitalWrite(10, 1);
  pinMode(11, OUTPUT);
  digitalWrite(11, 0);
}
void loop()
{
  int preverror;
  double filteredp = 0;
  double oplangle;
  double filteredc;

  // recieving the  input data from user for target set angle
  if (Serial.available() > 0)
  {
    for (int i = 0; i < 2; i++)
    {
      p[i] = Serial.read() - 48;
      delay(30);
    }
    int dat = (p[0] * 10) + (p[1]);
    SETANGLE = dat;
  }

  // reading accelerometer data --> tilt calculation with offset removal and averaging filter 
  int error;
  for (int j = 0; j < 20; j++)
  {
    int xRead = analogRead(xPin);
    int zRead = analogRead(zPin);
    xAng = map(xRead, minVal, maxVal, -90, 90);
    zAng = map(zRead, minVal, maxVal, -90, 90);
    y = RAD_TO_DEG * (atan2(-xAng, -zAng) + PI) - 273;
    filteredp += y;
    if (j == 19)
      filteredp = filteredp / 20;
  } 
  oplangle = (0.001 * previ * previ) + (0.21 * previ) - 6.5;
  filteredc = (1 - w) * filteredp + w * oplangle;
  
  
  error = SETANGLE - (int(filteredc));
  int_error += error; //calculating integral error
  i = i + (error * Kp) + ((error - preverror) * Kd) + (Ki * int_error); //calculating PID Controller components and feeding to input
  if (i > 190 || i < 0)
    i = 190;

  // writing the input to the system for subsequent operation.  
  analogWrite(3, byte(i)); 
 
  previ = i;
  preverror = error;

  // printing data for analysis
  Serial.print(error);
  Serial.print(" ");
  Serial.print(filteredc);
  Serial.print("  ");
  Serial.print(error);
  Serial.print("  ");
  Serial.println(i);
  
}
