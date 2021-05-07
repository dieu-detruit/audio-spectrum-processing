import com.hamoid.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

VideoExport videoExport;
Minim minim;
AudioPlayer player;
FFT fft;
int fftSize;

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
void setup()
{
    bg = loadImage("../thumb/" + date_string + ".png");

    minim = new Minim(this);
    fftSize = 512;
    //data = new float[fftSize][5];
    data = new float[fftSize];

    videoExport = new VideoExport(this, "nosound.mp4");
    player = minim.loadFile("../wav/" + date_string + ".wav", fftSize);

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

/*float median_filter(float[] x) {*/
/*y = */
/*}*/

void draw()
{
    background(bg);

    strokeWeight(10.0);
    stroke(255, 255, 255, 50);
    fill(255, 255, 255, 100);
    //rect(0, 0, width, ratio * height);
    //rect(0, height, width, -ratio * height);

    float amplitude = 200;

    float alpha = 0.6;
    int N = player.bufferSize();
    for (int i = 0; i < N - 1; ++i) {
        /*for(int j=0; j<4; ++j) {*/
        /*data[i][j] = data[i][j + 1] */
        /*}*/
        data[i] = alpha * data[i] + (1.0 - alpha) * player.left.get(i);
        float x1 = map(i, 0, N, 0, width);
        float x2 = map(i + 1, 0, N, 0, width);
        //float alpha = 50 * (1 - pow(i - N/2, 2) / pow(N/2, 2));
        //stroke(255, 255, 255, alpha);
        line(x1, height - 100 + amplitude * huber(player.left.get(i)), x2, height - 100 + amplitude * huber(player.left.get(i + 1)));
    }
    videoExport.saveFrame();

    if (!player.isPlaying()) {
        videoExport.endMovie();
    }
}
