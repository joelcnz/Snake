/++
Snake
+/
module main;

import base, snake, fruit;

// program start
int main(string[] args)
{	
	if (args.length == 1) {
		import std.stdio;

		writeln("Need a name, e.g. ./snake Joel");
		
		//return -1;
		args ~= "Testing";
	}
	import std.string;
	auto Contestent = args[1 .. $].join(" ");

	g_checkPoints = false;
	0.gh; // check point

	import std.datetime.stopwatch;
	StopWatch timer;
	timer.start;
	
	with(g_global) {
		enum WELCOME = "Welcome to Snake! Press [LSystem] + [Q] to quit";

		setup([320, 240], WELCOME);
		upDateStatus(WELCOME);
		g_window.setFramerateLimit(fps);
		contestent = Contestent;
		updateFPS = 10;
	}

	// main loop
    while (g_window.isOpen())
    {
        Event event; // to handle clicking the close button on the frame

        while(g_window.pollEvent(event)) // a loop for checking for events
        {
            if(event.type == event.EventType.Closed) // on the window frame
            {
                g_window.close();
            }
        }

		// for command + Q to quit/close program
		if (Keyboard.isKeyPressed(Keyboard.Key.LSystem)
			&&
			Keyboard.isKeyPressed(Keyboard.Key.Q) || g_keys[Keyboard.Key.Escape].keyPressed) {
			g_window.close;
		}

		with(g_global) {
			if (timer.peek.total!"msecs" > updateFPS * 10) {
				timer.reset;
				timer.start;
				snake.process;
			}
			snake.userControl;
		}

		g_window.clear(Color(0,0,0)); // clear the screen
		
		with(g_global) {
			fruit.draw;
			snake.draw;
			status.draw;
		}

        g_window.display(); // show all graphics changes
    }
	
	return 0; // return success
}
