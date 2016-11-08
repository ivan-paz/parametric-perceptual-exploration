//--------------------------------------------------------------
//
//
//--------------------------------------------------------------
s.boot;
//  import compression functions
"/home/ivan/documents/in-construction/rule_extraction_function.scd".load;
Ndef(\x).set(\freq, 12)
(
var window, system, system1;
var data = [ ];
var initialize, play, random, random1, random2;
var class1, class2, class3, class4;
var postdata, ruleExtraction, showrules;
window = Window.new("aa",Rect(650,300,500,300),resizable:true).front;

//------------------ load the systems    -------------------------
system = Ndef(\x,{
	arg freq, numharm, amp;
	var sig;
	sig = Blip.ar(freq,numharm) !2 * amp;
});
system1 = Ndef(\x1,{
	arg freq, freq2, amp;
	var sig;
	sig = Saw.ar(freq) + Saw.ar(freq - 1);
	sig = sig + ( Saw.ar(freq2) + Saw.ar(freq2) );
	sig = sig + Impulse.ar(20, amp/4);
	sig = sig!2;
	sig = FreeVerb.ar(sig, 0.33, 0.5, 0.5, 1) * amp;
});

//---------------------------------------------------------------
initialize = Button.new(window,Rect(20,50, 100, 55));
initialize.states = [["Initialize data"]];
initialize.action ={
	data = []; //Array to store classified parameter combinations
'data set to -> [ ] '.postln };

play = Button.new(window,Rect(20,110,100,55));
play.states = [["Play"],["Stop"]];
play.action = {arg val; if(val.value==1){system.play;'playing'.postln}{system.stop;'stop'.postln}};

random = Button.new(window,Rect(5,170,42,55));
random.states = [["Ran 1"]];
random.action = {var par; par = rrand(0,400);
system.set(\freq, par).getKeysValues.postln};
random1 = Button.new(window,Rect(49,170,42,55));
random1.states = [["Ran 2"]];
random1.action = {var par1; par1 = rrand(0,400);
system.set(\numharm, par1).getKeysValues.postln};
random2 = Button.new(window,Rect(93,170,42,55));
random2.states = [["Ran 3"]];
random2.action = {var par2; par2 = rrand(0,10)/10;
system.set(\amp, par2).getKeysValues.postln};

//   classification
// 1
class1 = Button.new(window,Rect(5,230,53,55));
class1.states =[['Class 1']];
class1.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 1'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(1);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
	'combination already in data'.postln
	}
};
// 2
class2 = Button.new(window,Rect(60,230,53,55));
class2.states =[['Class 2']];
class2.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 2'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(2);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
		'combination already in data'.postln
	}
};
// 3
class3 = Button.new(window,Rect(115,230,53,55));
class3.states =[['Class 3']];
class3.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 3'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(3);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
		'combination already in data'.postln
	}
};
//-------------------------------------------------------------------
postdata = Button.new(window,Rect(200,50,100,55));
postdata.states = [['show data']];
postdata.action = {'Data : '.postln;data.do{|x| x.postln}};

ruleExtraction = Button.new(window,Rect(200,110,100,55));
ruleExtraction.states = [['Rule Extraction']];
ruleExtraction.action = {
(~intervals_and_distances = [
	[
		[ [0,inf],  1000 ]
	],
	[
		[ [0,inf],  1000 ]
	],
	[
		[ [0, inf],  1 ]
	]
]);
//  Extract rules
~rules = ~subsetsCompression.value(data,~intervals_and_distances);
// unify intervals??
~classes = ~count_classes.value(data);
~bag = ~bagOfRules_uncompleted.value(~rules);
~split = ~splitRules_uncompleted.value(~bag)
};
showrules = Button.new(window,Rect(200,170,100,55));
showrules.states = [['bag of rules']];
showrules.action = {'bag of rules :'.postln;~split.do{|x,i|
	'Rules of Class '++i.asString.postln; x.postln}};
//----------------------------------------------------------------
//    play


)
~classes = ~count_classes.value(~bag)
~split = ~splitRules_uncompleted.value(~bag)
(
~splitRules_uncompleted = { |rules|
	var last, classes, array, splitedRules;
	if(rules.size != 0){
		last = ~classes.last;
		classes = (1 .. last);
		array = Array.fill2D(classes.size);
		rules.do{ |x|
			var evaluation;
			evaluation = x.last;
			classes.do{ |y, i|
				var temporal = [];
				if( evaluation == y) {
					temporal = array[y-1];
					temporal = temporal.add(x);
					array[ y - 1 ] = temporal
				}
			}
		};
		splitedRules = array;
	}}
);
[1,2,3,4].last






// Comunicate with processing via OSC
(
~osc = OSCresponder(n,"/parametres", {|...msg|
	~parametres = msg[2];
	Ndef(\x).set(
		\freq,  ~parametres[1].round(0.0001).linlin(0, 1,   0, 400),
		\freq2, ~parametres[2].round(0.0001).linlin(0,1, 0, 400),
		\amp,   ~parametres[3].round(0.0001).linlin(0,1,   0, 1));
	Ndef(\x).getKeysValues.postln
}).add;
~osc1 = OSCresponder(n, "/data", {|...msg|
	~instance = msg[2];
	~instance[1] = ~instance[1].round(0.0001).linlin(0,1, 0, 400);
	~instance[2] = ~instance[2].round(0.0001).linlin(0,1 ,0, 400);
	~instance[3] = ~instance[3].round(0.0001).linlin(0,1, 0,1);
	if(~data.indexOfEqual(~instance).isNil){~data = ~data.add(~instance)}
	{'already salved!'.postln}
}).add
)

// Stop data acquisition process and Ndef
(
~osc.remove;
~osc1.remove;
Ndef(\x).stop
)




//_________________________________________________________

//__________        rule extraction process     ___________


// Check the data
~data.do{ arg item; item.postln}


//  Save data session
//  dir = " /location/to/store/the/data"

//a = ~data.writeArchive("dir/dataFile");


//  Read session
//   ~data = Object.readArchive("dir/dataFile");


//  import compression functions
"/home/ivan/documents/ia/par_by_par_compression_algorithm/GeMuSE-SuperCollider/rule_extraction_function.scd".load;

//"/home/ivan/documents/ia/par_by_par_compression_algorithm/GeMuSE-SuperCollider/extra_functions.scd".load;


//--------------------------------------------------
//             set intervals and threshold for
//                     each parameter
//-------------------------------------------------
(~intervals_and_distances = [
      [
              [ [0,inf],  1000 ]
      ],
      [
              [ [0,inf],  1000 ]
      ],
	  [
		  [ [0, inf],  1]
	  ]
])


//  Extract rules
(
~cleanedData = ~cleanProcessingData.value(~data);
~rules = ~subsetsCompression.value(~cleanedData,~intervals_and_distances);
~bag = ~bagOfRules_uncompleted.value(~rules);
~split = ~splitRules_uncompleted.value(~bag);
)


//   Rules for each class are stored in ~split

//   Check the extracted rules
(
~split.do{ arg class;
	class.do{arg rule; rule.postln}
})


//------------------------------------------------------------------------
//  Play the rules and send the used patterns back to processing for visualization



~host = NetAddr("localhost", 12000); // Processing adress

(
Ndef(\x).set(\amp, 0);
Ndef(\x).play
)

(
Tdef(\sending,{
	arg values, cont = -1, rule;
	1.do{
		10.do{
			rule = ~selectRule.value(~split,0);
			rule.postln;
			Ndef(\x).set(\freq, rule[0], \freq2, rule[1], \amp, rule[2]- 0.25);
			rule[0] = rule[0].linlin(0,400, 0,1.0);
			rule[1] = rule[1].linlin(0,400, 0,1.0);
			rule[2] = rule[2].linlin(0,1.0, 0,1.0);
			rule[3] = rule[3].asFloat;
			cont = cont + 1;
			values = rule;
			o = OSCFunc(~host.sendMsg("/trigger", *values), s.addr);
			10.wait;
		};
		10.do{
			rule = ~selectRule.value(~split,1);
			rule.postln;
			Ndef(\x).set(\freq, rule[0], \freq2, rule[1], \amp, rule[2]-0.25);
			rule[0] = rule[0].linlin(0,400, 0,1.0);
			rule[1] = rule[1].linlin(0,400, 0,1.0);
			rule[2] = rule[2].linlin(0,1.0, 0,1.0);
			rule[3] = rule[3].asFloat;
			cont = cont + 1;
			values = rule;
			o = OSCFunc(~host.sendMsg("/trigger", *values), s.addr);
			10.wait;
		};
	};
})
)
Tdef(\sending).play

Tdef(\sending).stop

Ndef(\x).stop


