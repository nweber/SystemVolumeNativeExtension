// Copyright (C) <year> <copyright holders>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "FlashRuntimeExtensions.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

FREContext eventContext;

float getVolumeLevel()
{
    MPVolumeView *slide = [MPVolumeView new];
    UISlider *volumeViewSlider;
    
    for (UIView *view in [slide subviews])
    {
        if ([[[view class] description] isEqualToString:@"MPVolumeSlider"])
        {
            volumeViewSlider = (UISlider *) view;
        }
    }
    
    float val = [volumeViewSlider value];
    [slide release];
    
    return val;
}

void dispatchVolumeEvent(float volume)
{
    if (eventContext == NULL)
    {
        return;
    }
    
    NSNumber *numVolume = [NSNumber numberWithFloat:volume];
    NSString *strVolume = [numVolume stringValue];
    NSString *eventName = @"volumeChanged";
    
    const uint8_t* volumeCode = (const uint8_t*) [strVolume UTF8String];
    const uint8_t* eventCode = (const uint8_t*) [eventName UTF8String];
    FREDispatchStatusEventAsync(eventContext, eventCode, volumeCode);
}

void volumeListenerCallback(void *inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData)
{
    const float *volumePointer = inData;
    float volume = *volumePointer;
    
    dispatchVolumeEvent(volume);
}

FREObject init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    eventContext = ctx;
    
    // Listen to changes to system volume.
    
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(YES);
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, volumeListenerCallback, NULL);
    
    // Go ahead and send back current system volume.
    
    float curVolume = getVolumeLevel();
    dispatchVolumeEvent(curVolume);
    
    return NULL;
}

FREObject setVolume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    double newVolume;
    FREGetObjectAsDouble(argv[0], &newVolume);
    
    [[MPMusicPlayerController applicationMusicPlayer] setVolume: newVolume];
    
    return NULL;
}


void VolExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 2;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*) "init";
    func[0].functionData = NULL;
    func[0].function = &init;
    
    func[1].name = (const uint8_t*) "setVolume";
    func[1].functionData = NULL;
    func[1].function = &setVolume;
    
    *functionsToSet = func;
}

void VolumeExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &VolExtContextInitializer;
}