import gifAnimation.*;
import processing.video.*;

boolean lastPressed = false;
String path = "/eyes/";
String[] filenames;
Gif eyes;
ArrayList<PImage> frames;
int minTime;
int startTime;
boolean recording;
int gifFrameRate = 60;

Capture cam;
int capturedFrames;
GifMaker gifExport;
GifMaker gifPlayer;

void setup() {
  //Standard stuff
  size(640, 480);
  minTime = 1000 * 2;
  //Camera stuff
  cam = new Capture(this, 320, 240);
  cam.start();

  //Gif stuff
  capturedFrames = 0;
  filenames = listFileNames(sketchPath() + path);

  recording = false;

  println(filenames);
}





void draw() {
  if (keyPressed) {
    image(eyes, 0, 0);
    if (millis() - startTime > minTime) {
      if (!recording) {
        println("Started recording");
        gifExport = new GifMaker(this, path + year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".gif");
        gifExport.setDelay(gifFrameRate);
        recording = true;
      } else {
        if (frames.size() > 0) {
          frames.add(cam);
          gifExport.addFrame(frames.remove(0));
        } else {
          gifExport.addFrame(cam);
        }
      }
      gifExport.addFrame(cam);
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  if (!lastPressed) {
    lastPressed = true;
    startTime = millis();
    frames = new ArrayList<PImage>();
    newEyes();
  }
}

void keyReleased() {
  if (!recording) {
    println("Too short. Didnt save");
  }
  if (recording) {
    while (frames.size () > 0) {
      gifExport.addFrame(frames.remove(0));
    }
    gifExport.finish();
    recording = false;  
    println("gif saved");
  }
  lastPressed = false;
}

void newEyes() {
  String[] eyesList = listFileNames(sketchPath() + path);
  if (eyesList.length > 0) {
    println(eyesList);
    //Removed -1 from eyelist.length. Add if problems.
    int randIndex = (int)random(eyesList.length);
    String chosen = eyesList[randIndex];
    eyes = new Gif(this, path + chosen);
    eyes.play();
  } else {
    eyes = new Gif(this, "init.gif");
    eyes.play();
  }
}


// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}