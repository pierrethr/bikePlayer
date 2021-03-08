#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxSimpleGuiToo.h"

class testApp : public ofxiPhoneApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();

	void touchDown(int x, int y, int id);
	void touchMoved(int x, int y, int id);
	void touchUp(int x, int y, int id);
	void touchDoubleTap(int x, int y, int id);
	void touchCancelled(ofTouchEventArgs &touch);
	
	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);
	
	void gotMessage(ofMessage msg);
	
	ofImage arrow;
    
    bool bCheckpoint;
    int lastCheckPointTime;
    ofSoundPlayer player;
    float getSpeed (int timeDiff);
    float getSpeedByAngle(int angle);
	
    ofTrueTypeFont franklinBook14;
};
