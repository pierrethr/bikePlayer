#include "testApp.h"

int angleDiff = 0;
float pitch = 0.0f;
int checkInterval = 80;

int blinkInterval = 1000;
int lastBlink = 0;
bool bBlink = false;

int previousAngle = 0;
int lastAngleCheck = 0;

bool bDebug = false;

vector <int> angles;
int nMaxAngles = 20;

int maxAngle = 35;

//--------------------------------------------------------------
void testApp::setup(){	
	ofBackground(225, 225, 225);
    ofSetLogLevel(OF_LOG_NOTICE);
    
    ofTrueTypeFont::setGlobalDpi(72);
    franklinBook14.loadFont("frabk.ttf", 100);
    
    bCheckpoint = false;
    lastCheckPointTime = 0;
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
    
	arrow.loadImage("arrow.png");
	arrow.setAnchorPercent(1.0, 0.5);
    
    player.loadSound("track.wav");
    player.play();    
    player.setLoop(true);
    player.setSpeed(0.1f);
    
    gui.addTitle("Settings");
    gui.addSlider("Number of values", nMaxAngles, 1, 50);
    gui.addSlider("Max angle", maxAngle, 0, 180);
    gui.addSlider("CheckInterval", checkInterval, 0, 500);
    gui.addToggle("Blink", bBlink);
    gui.loadFromXML();
}


//--------------------------------------------------------------
void testApp::update() {
    ofSoundUpdate();
	//printf("x = %f   y = %f \n", ofxAccelerometer.getForce().x, ofxAccelerometer.getForce().y);
    float angle = 180 - RAD_TO_DEG * atan2( ofxAccelerometer.getForce().y, ofxAccelerometer.getForce().x );
    
    if (ofGetElapsedTimeMillis() - lastAngleCheck >= checkInterval) {
        player.setSpeed(getSpeedByAngle(angle));
        lastAngleCheck = ofGetElapsedTimeMillis();
    }
    
    
    blinkInterval = 520 - (pitch*500);
    if (blinkInterval < 10) blinkInterval = 10; 
    
    /*
    //ofLogNotice() << angle;
    if (angle > 240 && angle < 270) {
        if (!bCheckpoint) {
            bCheckpoint = true;
            int timeDiff = ofGetElapsedTimeMillis() - lastCheckPointTime;
            ofLogNotice() << timeDiff;
            
            lastCheckPointTime = ofGetElapsedTimeMillis();
            
            ofLogNotice("CHECKPOINT");
            
            player.setSpeed(getSpeed(timeDiff));
            ofLogNotice() << getSpeed(timeDiff);
        }
    } else {
        if (bCheckpoint) bCheckpoint = false;
    }
     */
}

//--------------------------------------------------------------
void testApp::draw() {
    
    if (bBlink) {
        if (ofGetElapsedTimeMillis() - lastBlink >= blinkInterval) {
            ofBackground(255, 255, 255);
            lastBlink = ofGetElapsedTimeMillis();
        } else if (ofGetElapsedTimeMillis() >= lastBlink + 20) {
            ofBackground(0, 0, 0);
        }
    } else {
        ofBackground(255, 255, 255);
    }
	
    
    if (bDebug) {
        ofSetColor(54);
        ofDrawBitmapString(ofToString(angleDiff), 10, 150);
        ofDrawBitmapString(ofToString(pitch), 10, 170);
    
        float angle = 270 - RAD_TO_DEG * atan2( ofxAccelerometer.getForce().y, ofxAccelerometer.getForce().x );
    
        ofEnableAlphaBlending();
        ofSetColor(0);
        ofPushMatrix();
            ofTranslate(ofGetWidth()/2, ofGetHeight()/2, 0);
            ofRotateZ(angle);
            //arrow.draw(0,0);
    
            franklinBook14.drawString(ofToString(angleDiff), 10, 100);
        ofPopMatrix();
    }
    
    gui.draw();
}


//--------------------------------------------------------------
float testApp::getSpeedByAngle(int angle) {
    int d = angle - previousAngle;
    if (d < 0) d *= -1;
    
    int a = abs(angle - previousAngle)%360;
    if (a > 180) {
        a = 360 - a;
    }
    
    d = a;
    angleDiff = d;
    //cout << d << endl;
    
    angles.push_back(d);    
    previousAngle = angle;
    
    if (angles.size() == nMaxAngles) {
        int sum = 0;
        for (int i=0; i<angles.size(); i++) {
            sum += angles[i];
        }
        pitch = ofMap(floor(sum/angles.size()), 0, maxAngle, 0.1, 1);
        //cout << floor(sum/angles.size());
        
        angles.clear();
        return (pitch);
    } else {
        return (pitch);
    }
    
    //checkInterval = ofMap(d, 100, 180, 500, 1500);
    //if (d < 100) checkInterval = 500;
    
    //if (d > 180 && pitch > 0.9) return (pitch);
    
    //pitch = ofMap(d, 0, 10, 0.1, 1);
    //s = 1-d;
    //cout << s << endl;
    
    //return (pitch);
}

//--------------------------------------------------------------
float testApp::getSpeed (int timeDiff) {
    
    float td = (float)timeDiff;
    pitch = ofMap(td, 0, 4000, 0.1, 2);
    pitch = 2-pitch;
    
    return (pitch);
}

//--------------------------------------------------------------
void testApp::exit() {

}

//--------------------------------------------------------------
void testApp::touchDown(int x, int y, int id){
	printf("touch %i down at (%i,%i)\n", id, x,y);
}

//--------------------------------------------------------------
void testApp::touchMoved(int x, int y, int id){
	printf("touch %i moved at (%i,%i)\n", id, x, y);
}

//--------------------------------------------------------------
void testApp::touchUp(int x, int y, int id){
	printf("touch %i up at (%i,%i)\n", id, x, y);
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(int x, int y, int id){
	printf("touch %i double tap at (%i,%i)\n", id, x, y);
    gui.toggleDraw();
    bDebug = !bDebug;
}

//--------------------------------------------------------------
void testApp::lostFocus() {
}

//--------------------------------------------------------------
void testApp::gotFocus() {
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning() {
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){

}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){
	
}

