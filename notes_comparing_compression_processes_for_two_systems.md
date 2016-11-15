# Notes comparing the rule extraction of two different systems



## Systems' description

1. Blip <br />  
A Band limited impulse generator. It produces a fundamental frequency to which a certain number of harmonics are added. All harmonics have equal amplitude. It is represented in the following way:<br />  

Blip (freq, numharm, amp); <br />  

Where freq is the fundamental frequency, numharm is the number of upper harmonics added, and amp is the amplitud of the signal.

2. Additive synthesis of Sawtooth waves <br />  
It consists of four sawtooth waves of frequencies freq, freq2, freq - 1 and freq2 + 1, all having the same amplittude denoted amp.


## Perceptual properties
For the experiment different perceptual properties were selected for each system. Those are described below. We need to have in mind that, as the system is designed for the exploration of general perceptual properties, it the consistency of the results with the selected perception which determines the parameters used during the rule extraction process.

1. Blip <br />
For this system the output perceptual properties selected where the following. Rhythmic, rough, and tone. This are generally described in the following way: <br />  
The sensation of rhythm is associalted with low fundamental frequencies (less than 20Hz), in which the number of harmonics added controls the perceived pitch of the sucessive beats. <br />  
The rough sensation is generally associated with fundamental frequencies around 15 and 35 Hz. However, the upper harmonics added create important variations in such perception. For example, if the number of harmonics is zero, frecuencies from around 20 to 45 are perceibes as pure tones.<br />  
Pure tone perception is generally associated with frequencies grater that 20 Hz without upper harmonics. However, also frequencies with high number of upper harmonics (>50) may also be perceibed as pure tones.<br />  

2. Additive synthesis of sawthooths<br/>
The selected perceptual property for this system was defined as follows:
The spectrum of frequencies was divided in three parts: 0 - 101, 101 - 201, 201 - 301. At each of this parts audible consonat (specially octaves) and low dissonant combination were choosen. To favor the compression of the data and to systematize the exploration process, one frequency remained static at each division while the other was varied.

## Data rule extraction thresholds and extracted rules

### Blip
The collected data is shown below.

|                                       | 
|---------------------------------------| 
| 0 , [ 11.354432, 20, 0.6, 1 ]         | 
| 1 , [ 10.203962, 20, 0.6, 1 ]         | 
| 2 , [ 5.504405, 20, 0.6, 1 ]          | 
| 3 , [ 1.854298, 230, 0.6, 1 ]         | 
| 4 , [ 7.653983, 230, 0.6, 1 ]         | 
| 5 , [ 15.012693, 230, 0.6, 1 ]        | 
| 6 , [ 4.294679, 230, 0.6, 1 ]         | 
| 7 , [ 20.425354, 260, 0.6, 2 ]        | 
| 8 , [ 24.548191, 260, 0.6, 2 ]        | 
| 9 , [ 21.10586, 260, 0.6, 2 ]         | 
| 10 , [ 21.10586, 67, 0.6, 2 ]         | 
| 11 , [ 21.10586, 370, 0.6, 2 ]        | 
| 12 , [ 21.10586, 26, 0.6, 2 ]         | 
| 13 , [ 99.598908, 7.928433, 0.6, 3 ]  | 
| 14 , [ 99.598908, 14.141092, 0.6, 3 ] | 
| 15 , [ 55.781054, 7.807612, 0.6, 3 ]  | 
| 16 , [ 55.781054, 1.90927, 0.6, 3 ]   | 

The extracted rules were extracted using [0, inf ] threshold 20, [0, inf] threshold 200 and [0,1] threshold  1 for the respective parameters.

class 1 <br />  
0 , [ 5.504405, 20, 0.6, 1 ] <br / >  
1 , [ 4.294679, 230, 0.6, 1 ] <br / >  
2 , [ [ 11.354432, 10.203962 ], 20, 0.6, 1 ] <br/>  
3 , [ [ 1.854298, 7.653983, 15.012693 ], 230, 0.6, 1 ] <br/>  

class 2 <br />  
0 , [ 21.10586, 26, 0.6, 2 ] <br />  
1 , [ [ 20.425354, 24.548191 ], 260, 0.6, 2 ] <br />  
2 , [ 21.10586, [ 260, 67, 370 ], 0.6, 2 ] <br />  

class 3 <br />  
0 , [ 99.598908, [ 7.928433, 14.141092 ], 0.6, 3 ] <br />  
1 , [ 55.781054, [ 7.807612, 1.90927 ], 0.6, 3 ]

### Additive Sawtooth
Collected data

|                                  | 
|----------------------------------| 
| 0 , [ 101, 20, 0.1, 1 ]          | 
| 1 , [ 101, 76.607595, 0.1, 1 ]   | 
| 2 , [ 101, 12.133835, 0.1, 1 ]   | 
| 3 , [ 101, 4.173377, 0.1, 1 ]    | 
| 4 , [ 101, 101, 0.1, 1 ]         | 
| 5 , [ 101, 50.5, 0.1, 1 ]        | 
| 6 , [ 152.462853, 101, 0.1, 2 ]  | 
| 7 , [ 135.960639, 101, 0.1, 2 ]  | 
| 8 , [ 105.081368, 101, 0.1, 2 ]  | 
| 9 , [ 155.236317, 101, 0.1, 2 ]  | 
| 10 , [ 201, 101, 0.1, 2 ]        | 
| 11 , [ 150, 101, 0.1, 2 ]        | 
| 12 , [ 201, 401.877295, 0.1, 3 ] | 
| 13 , [ 201, 399.408419, 0.1, 3 ] | 
| 14 , [ 201, 265.83709, 0.1, 3 ]  | 
| 15 , [ 201, 268.431116, 0.1, 3 ] | 
| 16 , [ 201, 301, 0.1, 3 ]        | 

The extracted rules used the following intervals and thresholds for the respective parameters: [0, inf] threshold of 10, [0,inf] threshold of 10 and for [0,inf] threshold of 1.

|                                                                        | 
|------------------------------------------------------------------------| 
|class 1                                                                 |
| 0 , [ 101, 20, 0.1, 1 ]                                                | 
| 1 , [ 101, 76.607595, 0.1, 1 ]                                         | 
| 2 , [ 101, 50.5, 0.1, 1 ]                                              | 
| 3 , [ 101, [ 12.133835, 4.173377, 101 ], 0.1, 1 ]  
|class 2                                                                 | 
| 0 , [ 152.462853, 101, 0.1, 2 ]                                        | 
| 1 , [ 135.960639, 101, 0.1, 2 ]                                        | 
| 2 , [ 105.081368, 101, 0.1, 2 ]                                        | 
| 3 , [ 155.236317, 101, 0.1, 2 ]                                        | 
| 4 , [ 201, 101, 0.1, 2 ]                                               | 
| 5 , [ 150, 101, 0.1, 2 ]
|class 3                                                                 | 
| 0 , [ 201, 301, 0.1, 3 ]                                               | 
| 1 , [ 201, [ 401.877295, 399.408419, 265.83709, 268.431116 ], 0.1, 3 ] | 


???  rules of class 3

 
