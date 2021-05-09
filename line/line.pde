import com.hamoid.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

VideoExport videoExport;
Minim minim;
AudioPlayer player;
int K;

PImage bg;
String date_string;

void settings()
{
    // if there are arguments, change the sketch's size
    if (args != null) {
        date_string = args[0];
    } else {
        exit();
    }
    print("date: " + date_string);

    size(1920, 1080);
}


//float[][] data;
float[] data;
float[] x1;
float[] x2;

void setup()
{
    bg = loadImage("../thumb/" + date_string + ".png");

    minim = new Minim(this);
    K = 512;
    //data = new float[K][5];
    data = new float[K];
    x1 = new float[K];
    x2 = new float[K];

    for (int i = 0; i < K - 1; ++i) {
        x1[i] = (float)width * i / K;
        x2[i] = (float)width * (i + 1) / K;
    }

    videoExport = new VideoExport(this, "nosound.mp4");
    player = minim.loadFile("../wav/" + date_string + ".wav", K);

    surface.setVisible(false);

    videoExport.startMovie();
    player.play();
    player.setGain(-10);
    frameRate(30);
}

float huber(float x)
{
    float threshold = 0.05;
    float sign = (x > 0) ? 1.0 : -1.0;
    if (abs(x) < threshold) {
        return sign * 0.5 * x * x / threshold;
    } else {
        return sign * (abs(x) - 0.5 * threshold);
    }
}

void draw()
{
    background(bg);

    strokeWeight(10.0);
    stroke(255, 255, 255, 50);
    fill(255, 255, 255, 100);
    //rect(0, 0, width, ratio * height);
    //rect(0, height, width, -ratio * height);

    float amplitude = 200;

    float alpha = 0.6, alpha_cmpl = 1.0 - alpha;
    int N = player.bufferSize();
    for (int i = 0; i < N - 1; ++i) {
        data[i] = alpha * data[i] + alpha_cmpl * player.left.get(i);
        line(x1[i], height - 100 + amplitude * player.left.get(i), x2[i], height - 100 + amplitude * player.left.get(i + 1));
    }
    videoExport.saveFrame();

    if (!player.isPlaying()) {
        videoExport.endMovie();
    }
}
