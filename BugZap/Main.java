

public class Main
{

    public void bugZap()
    {
        String[] a = {"MAIN"};
        processing.core.PApplet.runSketch( a, new BugZap());
    }


    public static void main(String[] args)
    {
        Main main = new Main();
        main.bugZap();
    }
} 