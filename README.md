# The Eye library: methods for extracting and analyzing Heart Rate Variability from a smart phone's camera

A set of function for extracting PPG from videos recorded by a smartphone’s camera. The tip of the finger should be resting on the camera, gently pressing the camera.
 
* Function readVideo() reads a video from a file and returns a cell array of 3 elements i.e. for red, green and blue channels, every element of the cell array is a three dimensional array i.e. I(x,y,t).
Example:
[subject{1}, framerate] = readVideo([video_path 'subject1.avi']);

* Function playVideo() visualize the cell array containing the video.
Example:
playVideo(subject{1}, framerate);


* Function videoToPPG() converts video to PPG signal. The function sums up all pixles in each frame, producing one sample of a PPG signal then removes extremely large values setting them to zero and applies pass-band filter.  

Example:
for k = 1:size(subject,2)
ppgs{k}{1} = videoToPPG(subject{k}{1}, framerate);
ppgs{k}{2} = videoToPPG(subject{k}{2}, framerate);
ppgs{k}{3} = videoToPPG(subject{k}{3}, framerate);
end
* 
Function localizeMaxima(), find peaks in a given PPG. The function first smooths the signal using Savitzky-Golay method and then apply findpeaks_ext() to find the maxima.
Example:
[maxLocs, avgInterval] = localizeMaxima(ppg, framerate);

* unction localizeMinima() finds minima in between the peaks detected by localizeMaxima ().
Example:
minLocs = localizeMinima(ppg, maxLocs);

* Function peakEnvelopeGivenPeaks() make use of maxima and minima to find the envelope of the signal.
Example:
env = peakEnvelopeGivenPeaks(ppg, minLocs, maxLocs);
* 
Function equalizeSignal() uses located minima and maxima to equalize the signal.
Example:
eqPpg = equalizeSignal(ppg, env);

* Function segmentBeats() splits an input signal into array of beats. The beats are resampled to have the same number of samples. 

Example:
beats = segmentBeats(ppg, minLocs, 30);

* Function findBestBeatShape() find the best shape of a heart beat shape. The function clusters all beats into a given number of clusters and return the closest beats to the centeroids as well as the centeroids itself. Besides the function returns indexes of those shapes that are close to the centroids and thus eliminates those beats which shapes are far from the beat shapes represented by the centroids.
Example:
[bestShape, beatCentroids_, goodBeatsIndx, hist] = findBestBeatShape(beats, 3);


* Function adjustBeats() interpolates samples around the peaks and finds a new maximum. 
Although a better model of a heart beat should be created.
Examples:
beatsLocs = adjustBeats(ppg, maxLocs(goodBeatsIndx), framerate);

* Heart rate variabitly is simply calculated as follows
hrv = diff(beatsLocs)/framerate;

* To fix intervals obtained from incorrectly detected beats, function postprocessHRV
() is used.
Example:
hrv_filtered = postprocessHRV(hrv);




