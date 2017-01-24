//--------------------------------------------------------------
//    Minimal gui for perceptual parametric exploration       --
//    of a simple generative system stored int an Ndef        --
//                                                            --
//                           Blip                             --
//                         Ivan Paz 2017                      --
//--------------------------------------------------------------
(
var window, system, system1;
var boot, location;
var data = [ ];
var initialize, play, random, random1, random2;
var par, par1, par2;
var box1,box2,box3,box4,box5,box6,a=0,b=400,c=0,d=100,e=0,f=1;
var class1, class2, class3, class4;
var delete, deleteInstance, selectInstance, number=nil;
var name, filename;
var postdata, ruleExtraction, split, saveData, loadData;
var csvdata, csvrules;
var tdef, playclass1, playclass2, playclass3;
var try1, try2, try3;
var text, text1;
var noclass;

// In OSX systems import files from the same directory with
// loadRelative("rule_extraction_function.scd");

// In linux change the location of rule_extraction_git.scd
location = "/home/ivan/documents/ia/par_by_par_compression_algorithm/parametric-perceptual-exploration/";
(location ++ "rule_extraction_git.scd").load;


//--------------------------     WINDOW   --------------------------//
window = Window.new("Exploring parameters Blip",Rect(650,330,510,450),resizable:true).front;
//------------------          system to explore     ------------------
system = Ndef(\x,{
	arg freq, numharm, amp;
	var sig;
	sig = Blip.ar(freq, numharm)!2;
	sig = FreeVerb.ar(sig, 0.23, 0.5, 0.5, 1) * amp;
});
//---------------------------------------------------------------
boot = Button.new(window, Rect(35, 10, 100, 30));
boot.states = [['boot'],['quit']];
boot.action = {arg val; if(val.value == 1){s.boot;
	'Exploring parameters interface!'.postln}{s.quit;'server off'.postln}
};

initialize = Button.new(window,Rect(35,50, 100, 30));
initialize.states = [["data = [ ]"]];
initialize.action ={
	data = []; //Array to store classified parameter combinations
'data set to -> [ ] '.postln };

play = Button.new(window,Rect(5,110,160,40));
play.states = [["play"],["stop"]];
play.action = {arg val; if(val.value==1){system.play;'playing'.postln}{system.stop;'stop'.postln}};

k = Knob.new(window, Rect(15, 170, 40, 40));
k.action = {arg v; par =  ( a +  ( (b - a) * v.value ) );
system.set(\freq, par).getKeysValues.postln };
//k.action_({ |v,x,y,m| postf("freq: %\n", v.value)});
l = Knob.new(window, Rect(70, 170, 40, 40));
l.action = {arg v; par1 = ( c + ( (d - c) * v.value  ) );
system.set(\numharm, par1).getKeysValues.postln };
m = Knob.new(window, Rect(125, 170, 40, 40));
m.action = {arg v; par2 = (e + ((f-e)* v.value  ));
system.set(\amp, par2).getKeysValues.postln };

//random = Button.new(window,Rect(5,170,53,55));
//random.states = [["Ran 1"]];
//random.action = {var par; par = rrand(a,b);
//system.set(\freq, par).getKeysValues.postln};
//random1 = Button.new(window,Rect(60,170,53,55));
//random1.states = [["Ran 2"]];
//random1.action = {var par1; par1 = rrand(c,d);
//system.set(\numharm, par1).getKeysValues.postln};
//random2 = Button.new(window,Rect(115,170,53,55));
//random2.states = [["Ran 3"]];
//random2.action = {var par2; par2 = rrand(e,f)/f;
//system.set(\amp, par2).getKeysValues.postln};

//-----
box1 = NumberBox(window, Rect(5, 230, 50, 30)).value_(0.0);
box1.action = {|val| a = val.value.postln};
box2 = NumberBox(window, Rect(5, 265, 50, 30)).value_(0.0);
box2.action = {|val| b = val.value.postln};
box3 = NumberBox(window, Rect(60, 230,50, 30)).value_(0.0);
box3.action = {|val| c = val.value.postln};
box4 = NumberBox(window, Rect(60, 265,50, 30)).value_(0.0);
box4.action = {|val| d = val.value.postln};
box5 = NumberBox(window, Rect(115,230,50, 30)).value_(0.0);
box5.action = {|val| e = val.value.postln};
box6 = NumberBox(window, Rect(115,265, 50,30)).value_(0.0);
box6.action = {|val| f = val.value.postln};

//----------------      classification        ----- ------------------
// 1
class1 = Button.new(window,Rect(5,320,53,55));
class1.states =[['Class 1']];
class1.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 1'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(1);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
	'combination already in data'.postln}
};
// 2
class2 = Button.new(window,Rect(60,320,53,55));
class2.states =[['Class 2']];
class2.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 2'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(2);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
		'combination already in data'.postln}
};
// 3
class3 = Button.new(window,Rect(115,320,53,55));
class3.states =[['Class 3']];
class3.action = {var values, instance = [];
	values = system.getKeysValues.post; '  Class 3'.postln;
	values.do{|x| instance = instance.add(x[1])};
	instance = instance.add(3);
	if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
		'combination already in data'.postln}
};
delete = Button.new(window, Rect(180, 330, 135, 30));
delete.states = [['remove last instance']];
delete.action = {var size = data.size;
	if(data.size==1){data = [];'last instance deleted!'.postln}{data = data[0..size - 2];'last instance deleted!'.postln}};


//-------------------------------------------------------------------
//                        processing data                       -----
//                                                              -----
//-------------------------------------------------------------------


name =  TextField(window, Rect(195, 10, 100, 20));
name.string = "file name";
name.action = {arg field; field.value.postln; filename=field.value};

loadData = Button.new(window, Rect(195, 40, 100, 30));
loadData.states = [['load data']];
loadData.action = {
	'loading data . . . '.postln;
	data = Object.readArchive(location ++ filename)
};

postdata = Button.new(window,Rect(195, 80, 100, 30));
postdata.states = [['show data']];
postdata.action = {'Data : '.postln;data.do{|x, i| i.post;' '.post; x.postln}};

ruleExtraction = Button.new(window,Rect(195, 120, 100, 30));
ruleExtraction.states = [['rule extraction']];
ruleExtraction.action = {
(~intervals_and_distances = [
	[
		[ [0,inf],  inf ]
	],
	[
		[ [0,inf],  inf ]
	],
	[
		[ [0, inf],  1 ]
	]
]);
//------------------------------------------------------------------
//                     Rule extraction process                    --
//------------------------------------------------------------------
~rules = ~subsetsCompression.value(data,~intervals_and_distances);
'----------------------------------------------'.postln;
'Rules : '.postln;
~rules.do{arg x, i; 'permutation: '.post;i.postln;x.do{arg y; y.postln}};
'------------------------------------------------------------'.postln;
};
split = Button.new(window,Rect(195,160,100,30));
split.states = [['rules by classes']];
split.action = {
~bagOfRules = ~bagOfRules_uncompleted.value(~rules);
~nonRedundant = ~redundant_rules.value(~bagOfRules);

~classes = ~count_classes.value(data);
~split = ~splitRules_uncompleted.value(~nonRedundant);
'Rules by classes : '.postln;
~split.do{arg x,i; 'class : '.post;(i+1).postln;x.do{arg y,j; j.post;'  '.post;y.postln}}
};
//-------------------------------------------------------------------

text = StaticText.new(window,Rect(195,200,100,10)).string_("-----------------------------");


saveData = Button.new(window, Rect(195, 220, 105, 25));
saveData.states = [['save data']];
saveData.action = {
	data.writeArchive(location ++ filename);
	'data saved into a file'.postln
};

csvdata = Button.new(window, Rect(180,255,65,30));
csvdata.states = [['data csv']];
csvdata.action = {
	f = File(location ++ filename ++ ".csv","w");
	data.do{arg x, i;
		f.write(i + "," + x + "\n");
	};
	f.close
};
csvrules = Button.new(window, Rect(250,255,65,30));
csvrules.states = [['rules csv']];
csvrules.action = {
	f = File(location ++ filename ++ "rules.csv","w");
	~split.do{arg x;
		x.do{arg y,j;
			f.write(j + "," + y + "\n")
		}};
		f.close
};

deleteInstance = Button.new(window, Rect(180, 295, 60, 30));
deleteInstance.states = [['delete']];
deleteInstance.action = {
	if( (number.class!=nil)&&(data!=[]) ){

		var tmp = [];
		data[number.asInteger] = nil;
		data.do{|x| if(x.notNil){tmp = tmp.add(x)}};
		data = tmp;
		'Instance deleted!  New data:'.postln;
		data.do{|x, i| i.post;' '.post;x.postln}

	}{'Error: empty data or missing index'.postln
}};
selectInstance = NumberBox.new(window, Rect(250, 295, 60, 30));
selectInstance.action = { |val|
	if((val.value).notNil){number = val.value.asInteger.postln}{
	'Error: please insert an Index'.postln}};




//----------------------------------------------------------------
//                             play                        -------
//----------------------------------------------------------------
//   -----               Rule selection functions    ------------
~selectRule = { |splitRules, class|
	var ruleTemp = [], rule = [];
	if( (splitRules[class]!=[]) && (splitRules[class].notNil) ){
		ruleTemp = splitRules[class].choose;
		ruleTemp.do{ |x|
			var value;
			if(x.class == Array){value = x.choose; rule = rule.add(value)}{rule = rule.add(x)};
		};
	}{'there are no rules for this class'.postln};
	rule
};
~generate = { arg rule;
	var instance;
	rule.collect({arg entrance;
		var value;
		if(entrance.class==Array){value = rrand(entrance.minItem,entrance.maxItem)}{value = entrance};
		instance = instance.add(value);
	});
	instance
};
//   ----------------------------------
~class = 0;
//Tdef(\sending,{ arg values, rule;
//	inf.do{
//		10.do{
//			rule = ~selectRule.value(~split,~class);
//			rule.postln;
//			Ndef(\x).set(\freq, rule[0], \numharm, rule[1],
//			\amp, rule[2]);
//			[ 7, 3, 5].choose.wait;
//		};
//		5.do{
//			rule = ~selectRule.value(~split,~class);
//			rule.postln;
//			Ndef(\x).set(\freq, rule[0], \numharm, rule[1],
//			\amp, rule[2]);
//			[1, 0.5, 0.25].choose.wait;
//		}
//	}
//});
//---------------------------------------------------------
//tdef = Button.new(window,Rect(350,170,100,50));
//tdef.states = [['Sequence'],['Stop']];
//tdef.action = {|val| if(val.value == 1){Tdef(\sending).play; 'playing'.postln}{Tdef(\sending).stop; 'stop'.postln }};

playclass1 = Button.new(window,Rect(330,110,53,55));
playclass1.states =[['Play-1']];
playclass1.action = {var rule;
	~class = 0; 'class 1 selected'.postln;
	rule = ~selectRule.value(~split,~class).postln;
	system.set(\freq,rule[0],\numharm,rule[1],\amp,rule[2]);
};
playclass2 = Button.new(window,Rect(390,110,53,55));
playclass2.states =[['Play-2']];
playclass2.action = {var rule;
	~class = 1; 'class 2 selected'.postln;
	rule = ~selectRule.value(~split,~class).postln;
	system.set(\freq,rule[0],\numharm,rule[1],\amp,rule[2])
};
playclass3 = Button.new(window,Rect(450,110,53,55));
playclass3.states =[['Play-3']];
playclass3.action = {var rule;
	~class = 2; 'class 3 selected'.postln;
	rule = ~selectRule.value(~split,~class).postln;
	system.set(\freq, rule[0], \numharm, rule[1], \amp, rule[2])
};

//////////////////////////////////////////////////////////////
//          generate function create a new instance
//        with random values taken from the intervals
//               created during the compression
//////////////////////////////////////////////////////////////
try1 = Button.new(window, Rect(330, 200, 53, 55));
try1.states = [['Try-1']];
try1.action = {var rule, newInstance;
	rule = ~split[0].choose;
	newInstance = ~generate.value(rule);
	system.set(\freq, newInstance[0], \numharm, newInstance[1], \amp, newInstance[2]);
	newInstance.postln
};
try2 = Button.new(window, Rect(390, 200, 53, 55));
try2.states = [['Try-2']];
try2.action = {var rule, newInstance;
	rule = ~split[1].choose;
	newInstance = ~generate.value(rule);
	system.set(\freq, newInstance[0], \numharm, newInstance[1], \amp, newInstance[2]);
	newInstance.postln
};
try3 = Button.new(window, Rect(450, 200, 53, 55));
try3.states = [['Try-3']];
try3.action = {var rule, newInstance;
	rule = ~split[2].choose;
	newInstance = ~generate.value(rule);
	system.set(\freq, newInstance[0], \numharm, newInstance[1], \amp, newInstance[2]);
	newInstance.postln
};

text1 = StaticText.new(window,Rect(330,250,200,50)).string_("----------------------------------------");

//------------------------------------------------------------//
//                  classify unseen combinations              //
//                         if necessary                       //
//----------------------------------------------------------- //
// 1
class1 = Button.new(window,Rect(330,320,53,55));
class1.states =[['Class 1']];
class1.action = {var values, instance = [];
values = system.getKeysValues.post; ' classified as Class 1'.postln;
values.do{|x| instance = instance.add(x[1])};
instance = instance.add(1);
if(data.indexOfEqual(instance).isNil){data = data.add(instance
)}{
	'combination already in data'.postln}
};
// 2
class2 = Button.new(window,Rect(330+60,320,53,55));
class2.states =[['Class 2']];
class2.action = {var values, instance = [];
values = system.getKeysValues.post; ' classified as Class 2'.postln;
values.do{|x| instance = instance.add(x[1])};
instance = instance.add(2);
if(data.indexOfEqual(instance).isNil){data = data.add(instance
)}{
	'combination already in data'.postln}
};
// 3
class3 = Button.new(window,Rect(330+120,320,53,55));
class3.states =[['Class 3']];
class3.action = {var values, instance = [];
values = system.getKeysValues.post; ' classified as Class 3'.postln;
values.do{|x| instance = instance.add(x[1])};
instance = instance.add(3);
if(data.indexOfEqual(instance).isNil){data = data.add(instance
)}{
	'combination already in data'.postln}
};

noclass = Button.new(window, Rect(180, 380, 135 ,40));
noclass.states = [['no-class combination']];
noclass.action = {var values, instance = [];
values = system.getKeysValues.post;" this combination doesn't belong to any     class".postln;
values.do{|x| instance = instance.add(x[1])};
instance = instance.add(4);
if(data.indexOfEqual(instance).isNil){data = data.add(instance)}{
'this combination was already saved'.postln}
}


)

