//---------------------------------------------------------------
//                      Analytic Interface                  -----
//       for perceptual exploration of parametric spaces    -----
//                          Ivan Paz                        -----
//---------------------------------------------------------------
(
var location, system;
var windowx = 250, windowy = 500;
var window, play_stop;
var box1, value;//parameter_number,box2,min_val,box3,max_val,box4,value;
var par1;

// In OSX systems import files from the same directory
// loadRelative("rule_extraction_function.scd");
// In linux change the location of rule_extraction_git.scd
location = "/home/ivan/documents/ia/par_by_par_compression_algorithm/parametric-perceptual-exploration/";
(location ++ "rule_extraction_git.scd").load;

//s.boot; //Boot the system

window = Window.new("Perceptual Exploration of a Parametric Generative System ",Rect(800,280,windowx,windowy),resizable:true).front;
system = Ndef(\x,{
	arg freq = 200, numharm = 2, amp = 0.3;
	var sig;
	sig = Blip.ar(freq, numharm)!2;
	sig = FreeVerb.ar(sig, 0.23, 0.5, 0.5, 1) * amp;
});

play_stop = Button.new(window, Rect(windowx/3, 10, windowx/3, 30));
play_stop.states = [['play / stop'],['play / stop']];
play_stop.action = {arg val; if(val.value == 1)
{system.play; 'the Ndef is playing now :)'.postln}
{system.stop; 'the Ndef has stopped :('.postln}};

//box1 = NumberBox(window, Rect(0*windowx, 70, windowx/7, 20));
//box1.action = {|val| parameter_number = val.value.postln};
//box2 = NumberBox(window, Rect((2/7)*windowx, 70, windowx/7, 20));
//box2.action = {|val| min_val=val.value.postln};
//box3 = NumberBox(window, Rect((4/7)*windowx, 70, windowx/7, 20));
//box3.action = {|val| max_val = val.value.postln};
box1 = NumberBox(window, Rect((6/7)*windowx, 70, windowx/7, 20));
box1.action = {|val| value = val.value.postln};
par1 = Button.new(window,Rect(0 * windowx, 110, windowx/3, 30));
par1.states = [['param 1']];


)



(
	var window, size = 32; // try different sizes - from 15 to 200 or more!
	window = Window.new("Knob", Rect(640,630,270,70)).front;
	k = Knob.new(window, Rect(20, 10, size, size));
	k.action_({|v,x,y,m| postf("action func called: %\n", v.value); });
	//k.color[1] = Color.gray(alpha:0);
)




