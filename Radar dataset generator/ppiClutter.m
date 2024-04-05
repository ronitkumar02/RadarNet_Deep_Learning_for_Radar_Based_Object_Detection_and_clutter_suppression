function ppiClutter(Length, Width, Height, Filename,random_m,random_m1,random_k,random_k1,random_t_ang,random_t_deg,random_t_deg1)
    rng default

    freq   = 10e9; % Hz
    azbw   = 1;    % deg
    rngres = 14;   % m

    sinc3db  = 0.8859;
    numelems = round(2*sinc3db/deg2rad(azbw));
    lambda   = freq2wavelen(freq);
    array    = phased.ULA(numelems,lambda/2);
    array.Element.BackBaffled = true;

    rotrate   = 50/60*360;   % deg/sec
    rotperiod = 360/rotrate; % sec
    
    npulses = ceil(360/azbw);
    prf = npulses/rotperiod; % Hz
    
    sampleRate = 1/range2time(rngres); % Hz
    sampleRate = prf*round(sampleRate/prf);
    rngres = time2range(1/sampleRate); % m
    sampleTime = 1/sampleRate;         % s
    
    rdr = radarTransceiver;
    rdr.TransmitAntenna.OperatingFrequency = freq;
    rdr.ReceiveAntenna.OperatingFrequency = freq;
    rdr.TransmitAntenna.Sensor = array;
    rdr.ReceiveAntenna.Sensor = array;
    rdr.Waveform.PRF = prf;
    rdr.Receiver.SampleRate = sampleRate;
    rdr.Waveform.SampleRate = sampleRate;
    rdr.Waveform.PulseWidth = 1/sampleRate;
    
    scenario = radarScenario('UpdateRate',0);
    
    
    seaLength = 2e3; % m
    
    
    seaRes = rngres/4; % m
    seaRes = seaLength/round(seaLength/seaRes);
    spec   = seaSpectrum('Resolution',seaRes);
    
    refl = surfaceReflectivitySea('Model','NRL','SeaState',5,'Polarization','H');
    
    
    windSpeed = 10; % m/s
    windDir   = 0; % deg
    bdry      = [-1 1;-1 1]*seaLength/2; % m
    seaSurface(scenario,'Boundary',bdry,'RadarReflectivity',refl,'SpectralModel',spec,'WindSpeed',windSpeed,'WindDirection',windDir);
    
    rdrHeight = 24; % m
    traj = kinematicTrajectory('Position',[0 0 rdrHeight],'AngularVelocitySource','Property','AngularVelocity',[0 0 deg2rad(rotrate)]);
    platform(scenario,'Sensors',rdr,'Trajectory',traj);
    
    %tgtdims = struct('Length',120,'Width',18,'Height',22,'OriginOffset',[0 0 0]); % m
    tgtdims = struct('Length',Length,'Width',Width,'Height',Height,'OriginOffset',[0 0 0]);
    tgtdims1 = struct('Length',Length,'Width',Width,'Height',Height,'OriginOffset',[0 0 0]);% m
    tgtrcs = 40;  % dBsm
    tgtrcs1= 40;
    m=random_m;
    m1=random_m1;
    k=random_k;
    k1=random_k1;
    tgtpos = [m1*seaLength/3 m*seaLength/16 5];
    tgtpos1=[k1*seaLength/3 k*seaLength/16 5];
    tgthdg = random_t_deg; % deg
    tgthdg1 = random_t_deg1;
    tgtspd = 8;   % m/s
    tgtspd1 = 8;
    
    tgtvel = tgtspd*[cosd(tgthdg) sind(tgthdg) 0];
    tgtvel1 = tgtspd1*[cosd(tgthdg1) sind(tgthdg1) 0];
    tgttraj = kinematicTrajectory('Position',tgtpos,'Velocity',tgtvel,'Orientation',rotz(tgthdg).');
    tgttraj1 = kinematicTrajectory('Position',tgtpos1,'Velocity',tgtvel1,'Orientation',rotz(tgthdg1).');
    platform(scenario,'Trajectory',tgttraj,'Signatures',rcsSignature('Pattern',tgtrcs),'Dimensions',tgtdims);
    platform(scenario,'Trajectory',tgttraj1,'Signatures',rcsSignature('Pattern',tgtrcs1),'Dimensions',tgtdims1);
    
    clut = clutterGenerator(scenario,rdr,'UseBeam',false,'Resolution',rngres/2);
    minGndRng = 200;
    maxGndRng = seaLength/2;
    azCov = 16*azbw;
    azCen = 0;
    reg = ringClutterRegion(clut,minGndRng,maxGndRng,azCov,azCen);
    
    resp = phased.RangeResponse('RangeMethod','Matched filter','SampleRate',sampleRate);
    mfc = getMatchedFilter(rdr.Waveform);
    
    azcov = random_t_ang;
    
    scenario.StopTime = azcov/360*npulses/prf;
    
    frame = 0;
    nrng = floor(time2range(1/prf)/rngres);
    
    minRange = sqrt(minGndRng^2 + rdrHeight^2);
    maxRange = sqrt(maxGndRng^2 + rdrHeight^2);
    rngbins = [0 time2range((1:(nrng-1))*sampleTime)].';
    minGate = find(rngbins >= minRange,1,'first');
    maxGate = find(rngbins <= maxRange,1,'last');
    nrng = maxGate - minGate + 1; 
    nframes = scenario.StopTime*prf + 1; 
    ppi = zeros(nrng,nframes);
    rngbins = rngbins(minGate:maxGate);
    while advance(scenario)
        % Advance frame
        frame = frame + 1;
        reg.AzimuthCenter = (frame-1)*rotrate/prf;
    
        % Collect IQ data 
        iqsig = receive(scenario);
    
        % Pulse compress and add to PPI 
        iqPC = resp(sum(iqsig{1},2),mfc);
        ppi(:,frame) = iqPC(minGate:maxGate); 
    end
    
    az = rotrate*(0:frame)/prf;
    gndrng = sqrt(rngbins.^2-rdrHeight^2);
    x = gndrng.*cosd(az);
    y = gndrng.*sind(az);
    figure()
    surface(x,y,zeros(size(x)),mag2db(abs(ppi)))
    shading flat
    view(0,90)
    colorbar
    clim([-120 20])
    axis equal
    axis tight
    colormap winter
    title('PPI Image')
    set(gcf,'Visible', 'off');
    saveas(gcf, Filename)

end

function helperPlotScenarioGeometry(rdrHeight,seaLength,array,freq,tgtpos)
helperPlotScenarioGeometry(rdrHeight,seaLength,array,freq,tgtpos1)
% Plot a visualization of the scenario

fh = figure;

% Surface
t = 0:10:360;
r = linspace(0,seaLength/2,10).';
x = r.*cosd(t);
y = r.*sind(t);
co = colororder; 
surface(x/1e3,y/1e3,zeros(size(x)),repmat(permute(co(6,:),[1 3 2]),[size(x) 1]),'EdgeColor','flat')
hold on

% Antenna pattern
az = linspace(-6,6,80);
maxEl = -atand(2*rdrHeight/seaLength);
el = linspace(-90,maxEl,80);
G = pattern(array,freq,az,el);
[az,el] = meshgrid(az,el);
[x,y,~] = sph2cart(az*pi/180,el*pi/180,1);
rtg = rdrHeight./sind(-el);
surface(x.*rtg/1e3,y.*rtg/1e3,1e-2*ones(size(x)),G,'EdgeColor','flat')

% Radar
line(0,0,rdrHeight,'Color',co(1,:),'Marker','o','MarkerFaceColor',co(1,:))
line([0 0],[0 0],[0 rdrHeight],'Color','black','linestyle','--')

% Target
line(tgtpos(1)/1e3,tgtpos(2)/1e3,tgtpos(3),'Marker','*','Color',co(7,:))
line(tgtpos1(1)/1e3,tgtpos1(2)/1e3,tgtpos1(3),'Marker','*','Color',co(7,:))
hold off

% Add text
text(0,0,rdrHeight*1.1,'Radar')
text(tgtpos(1)*.8/1e3,tgtpos(2)*1.1/1e3,rdrHeight/10,'Target')
text(tgtpos1(1)*.8/1e3,tgtpos1(2)*1.1/1e3,rdrHeight/10,'Target')
text(seaLength/4/1e3,-200/1e3,rdrHeight/10,'Beam Pattern')
text(-seaLength/4/1e3,seaLength/4/1e3,rdrHeight/10,'Sea Surface')

% Add labels
xlabel('X (km)')
ylabel('Y (km)')
zlabel('Z (m)')
title('Scenario Geometry')

% Set color limits
cl = clim;
clim([cl(2)-30 cl(2)])

fh.Position = fh.Position + [0 0 150 150];
view([-11 58])
pause(0.5)
end
