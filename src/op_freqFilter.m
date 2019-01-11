function [ fIltSignal ] = op_freqFilter( signal,filtType,sampFreq,freqCut,freqCen,freqBand,filtOrder,plotMode)
% #########################################################################
% GuardOne 1.0.0 (source code generated 2017-07-27)
% Copyright (c) OnePredict(GuardOne project).
%  
% >>> SOURCE LICENSE >>>
% This program is the GuardOne package  licensed to OnePredict.Inc (Licensee, You).
% Only  Have the Licensee can use  it  according   to   the  OnePredict. Licensee.
% #########################################################################
% @description          Fourier transform
% @Version              1.0
% @Technical Author     Taewan Hwang (michel4546@gmail.com)
% @Author               Taewan Hwang (michel4546@gmail.com)
% @contact              www.onepredict.com/
% @copyright            Copyright (C) OnePredict, Inc  - All Right Reserved
% @WARRANTIES:
%  
% This version provided for SHRM,  with  no  warranties, express or implied.
%  
% COPYRIGHT:
% You  will not remove  any copyright notice  from  the files.  You  agree  to
% prevent any unauthorized  copying  of  the  this software.  Except  as
% expressly provided herein, Licensor does not grant any  express
% or implied right to you  under  Licensor  patents,  copyrights,
% trademarks, or trade secret information.
% #########################################################################
% Frequency filter
%  
% Signal is filtered with butterworth/ideal type frequency filter.
% 
% INPUT PARAMETERS
%     signal   -   array, target 1d signal
%     filtType   -  char, type of filter
%               'lowpass': low pass filter (butterworth type)
%               'highpass': high pass filter (butterworth type)
%               'bandpass': band pass filter (butterworth type)
%               'bandstop': notch filter (butterworth type)
%               'bandpass(ideal)': band pass filter(ideal)
%               'bandstop(ideal)': notch filter(ideal)
%     sampFrequency   -  float, sampling frequency of signal
%     freqCut - float, cutoff frequency for lowpass, highpass filter
%     freqCen   -  float, center frequency for bandpass, bandstop filter
%     freqBand  -  float, band wiidth for bandpass, bandstop filter
%     plotMode  -  boolean, figure on(1)/off(0)
% OUTPUT PARAMETERS
%     fIltSignal   -   filtered signal
% #########################################################################

signal=signal(:);
freqCen=freqCen(:);
freqBand=freqBand(:);

switch filtType
    case 'lowpass' % low pass filter (butterworth type)
        Wn=freqCut;
        Fn=sampFreq/2;
        [b,a]=butter(filtOrder,Wn/Fn,'low');
        fIltSignal=filter(b,a,signal);
        if plotMode
            % filter response
            freqz(b,a);
        end
    case 'highpass' % high pass filter (butterworth type)
        Wn=freqCut;
        Fn=sampFreq/2;
        [b,a]=butter(filtOrder,Wn/Fn,'high');
        fIltSignal=filter(b,a,signal);
        if plotMode
            % filter response
            freqz(b,a);
        end
        
    case 'bandpass' % band pass filter (butterworth type)
        Wn=[freqCen-freqBand/2 freqCen+freqBand/2];
        Fn=sampFreq/2;
        band=Wn/Fn;
        [b,a]=butter(filtOrder,band,'bandpass');
        fIltSignal=filter(b,a,signal);
        if plotMode
            % filter response
            freqz(b,a);
        end
    case 'bandstop' % notch filter (butterworth type)
        Wn=[freqCen-freqBand/2 freqCen+freqBand/2];
        Fn=sampFreq/2;
        band=Wn/Fn;
        [b,a]=butter(filtOrder,band,'stop');
        fIltSignal=filter(b,a,signal);
        if plotMode
            % filter response
            freqz(b,a);
        end
    case 'bandpass(ideal)' % manual band pass filter
        if length(freqCen)~=length(freqBand)
            error('Invalid size for frequency center, frequency band')
        else
            [fHalf,fFull,~,~,yHalf,yFull]=op_FFT(signal,sampFreq,0,0);
            BandIdx=[];
            for bandIdx=1:length(freqCen)
                Band1Low=freqCen(bandIdx)-freqBand(bandIdx)/2; % band1: half below sampling frequency
                Band1High=freqCen(bandIdx)+freqBand(bandIdx)/2;
                Band2Low=sampFreq-(freqCen(bandIdx)+freqBand(bandIdx)/2); % band2: half upper sampling frequency
                Band2High=sampFreq-(freqCen(bandIdx)-freqBand(bandIdx)/2);
                
                Band1LowIdx=find(fFull>=Band1Low,1); % first exceed index -1
                Band1HighIdx=find(fFull>=Band1High,1)-1; % First exceed index +1
                Band2LowIdx=find(fFull>=Band2Low,1); % first exceed index -1
                Band2HighIdx=find(fFull>=Band2High,1)-1; % First exceed index +1
                
                Band1Idx=[Band1LowIdx:Band1HighIdx];
                Band2Idx=[Band2LowIdx:Band2HighIdx];
                
                BandIdx=[BandIdx,Band1Idx,Band2Idx];
            end
            FullIdx=1:length(fFull);
            NotchIdx=setdiff(FullIdx,BandIdx);

            FiltYFull=yFull;
            FiltYFull(NotchIdx)=0;
            cutoff=ceil(length(FiltYFull)/2);
            FiltYHalf=FiltYFull(1:cutoff);
            
            fIltSignal=real(ifft(FiltYFull));
        
            if plotMode
                % filter response
                H=FiltYHalf./yHalf;
                normFreq=fHalf/(sampFreq/2);
                mag=real(H);
                ang=angle(H)*180/pi;
                figure;
                subplot(2,1,1);
                plot(normFreq,mag);
                xlabel('Normalized Frequency');
                ylabel('Magnitude');

                subplot(2,1,2);
                plot(normFreq,ang);
                xlabel('Normalized Frequency');
                ylabel('Phase(degrees)');
            end
        end
    case 'bandstop(ideal)' % manual notch filter
        if length(freqCen)~=length(freqBand)
            error('Invalid size for frequency center, frequency band')
        else
            [fHalf,fFull,~,~,yHalf,yFull]=op_FFT(signal,sampFreq,0,0);
            NotchIdx=[];
            for notchIdx=1:length(freqCen)
                Notch1Low=freqCen(notchIdx)-freqBand(notchIdx)/2; % band1: half below sampling frequency
                Notch1High=freqCen(notchIdx)+freqBand(notchIdx)/2;
                Notch2Low=sampFreq-(freqCen(notchIdx)+freqBand(notchIdx)/2); % band2: half upper sampling frequency
                Notch2High=sampFreq-(freqCen(notchIdx)-freqBand(notchIdx)/2);
                
                Notch1LowIdx=find(fFull>=Notch1Low,1); % first exceed index -1
                Notch1HighIdx=find(fFull>=Notch1High,1)-1; % First exceed index +1
                Notch2LowIdx=find(fFull>=Notch2Low,1); % first exceed index -1
                Notch2HighIdx=find(fFull>=Notch2High,1)-1; % First exceed index +1
                
                Notch1Idx=[Notch1LowIdx:Notch1HighIdx];
                Notch2Idx=[Notch2LowIdx:Notch2HighIdx];
                
                NotchIdx=[NotchIdx, Notch1Idx,Notch2Idx];
            end
            FiltYFull=yFull;
            FiltYFull(NotchIdx)=0;
            cutoff=ceil(length(FiltYFull)/2);
            FiltYHalf=FiltYFull(1:cutoff);
            
            fIltSignal=real(ifft(FiltYFull));
            if plotMode
                % filter response
                H=FiltYHalf./yHalf;
                normFreq=fHalf/(sampFreq/2);
                mag=real(H);
                ang=angle(H)*180/pi;
                figure;
                subplot(2,1,1);
                plot(normFreq,mag);
                xlabel('Normalized Frequency');
                ylabel('Magnitude');
                
                subplot(2,1,2);
                plot(normFreq,ang);
                xlabel('Normalized Frequency');
                ylabel('Phase(degrees)');
            end
        end
        
    otherwise
        error('Invalid filter type');
end
if plotMode
    % time domain signal/filtered signal
    Nx=length(signal);
    time=1/sampFreq:1/sampFreq:1/sampFreq*Nx;
    figure;
    subplot(2,1,1);
    plot(time,signal)
    title('Orignal signal')
    xlabel('Time(sec)')
    ylabel('Y(t)')
    
    subplot(2,1,2);
    plot(time,fIltSignal)
    title('Filtered signal')
    xlabel('Time(sec)')
    ylabel('Y(t)')
    
    
    % frequency domain signal/filtered signal
    [freqHalf,~,YHalf,~,~,~]=op_FFT(signal,sampFreq,0,0);
    [~,~,filtYHalf,~,~,~]=op_FFT(fIltSignal,sampFreq,0,0);
    figure; 
    hold on;
    stem(freqHalf,YHalf)    
    stem(freqHalf,filtYHalf,'r')
    title('Spectrum')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    legend('original','filtered');
end


end

