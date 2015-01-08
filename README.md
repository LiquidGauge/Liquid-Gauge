Liquid Gauge
==============

This library provides an **easy to use and fully customizable class to simulate liquid** in a view.

The view content is based on a percentage and is usable as a **gauge**.

The liquid view has fully customizable appearance and behavior. (See configuration section)

The view should be used with a **mask** in front of it to simulate the container.

![Demo](/Screenshots/gauge.png?raw=true "Liquid Gauge")

ScreenShots
----------------
![ScreenShots](/Screenshots/no-mask.jpg?raw=true "Liquid Gauge without mask")
![ScreenShots](/Screenshots/mask-1-1.jpg?raw=true "Liquid Gauge with circle mask")
![ScreenShots](/Screenshots/mask-1-2.jpg?raw=true "Liquid Gauge with circle mask")
![ScreenShots](/Screenshots/mask-2.jpg?raw=true "Liquid Gauge with thermometer mask")

Installation
----------------
### From CocoaPods

####/!\ Not yet support by swift /!\

The recommended approach for installating ```LiquidView``` is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation:

```bash
$ [sudo] gem install cocoapods
$ pod setup
```
Change to the directory of your Xcode project:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
```

Edit your Podfile and add LiquidView:

``` bash
platform :ios, '7.0'
pod 'Liquid-Gauge', '~> 1.0'
```

Install into your Xcode project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= **1.8.0** by executing `git --version`. You can get a full picture of the installation details by executing `pod install --verbose`.



### Manually

#### LiquidGauge manual installation
Download Liquid gauge project. You can download it directly from his [github page](https://github.com/Loadex/Liquid-Gauge)  
or via the command line :
``` bash
$ git clone https://github.com/Loadex/Liquid-Gauge.git
```
Drag the ```Liquid Gauge``` folder into your project.

Quick Start Guide
----------------


Class documentation
----------------
###LiquidView class documentation
The **LiquidView class** provide the following methods

```
func startMotion() -> Void
```
Start the motion detection.
Should be call in the ```viewDidAppear``` function.
Will simulate the **movement of the liquid** with the device orientation.

```
func stopMotion() -> Void
```
Stop the motion detection.
Should be call in the ```viewDidDisappear``` function.

Delegate methods
----------------
The ```LiquidView``` class implements a delegate protocol with the following **optional** methods:

```
func liquidView(liquidView: LiquidView, colorForPercent percent:Float) -> UIColor!
```
**Parameters description**

* ```liquidView``` The liquidView changing is value and asking for the color the liquid should be.
* ```percent``` The current value of the gauge (between 0 and 100).

**Return value description**

* An ```UIColor``` representing the color of the gauge liquid

Datasource methods
----------------

The ```LiquidView``` class implements a datasource protocol with the following **mandatory** method:

```func gaugeValue(liquidView: LiquidView) -> Float```

Current value of the gauge in percent (%)

**Parameters description**

* ```liquidView``` The liquidView asking for the gauge level/value


And the following **optional** methods:

```func waveFrequency(liquidView: LiquidView) -> Float```
 
Frequency of the liquid's waves
 
**Parameters description**

* ```liquidView``` The liquidView asking for frequency of the liquid waves

```func waveAmplitude(liquidView: LiquidView) -> Float```
  
Size of the waves
 
**Parameters description**

* ```liquidView``` The liquidView asking for the size of the displayed waves


Roadmap
----------------
To be determined 

FAQ
----------------
No question asked so far.

Requirements
----------------
This project require :

+ ```iOS7```
+ ```Swift```

Licence
----------------
MIT Licence  
Copyright (c) 2014 Benjamin BUSINARO <busina_b@epitech.eu>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


Repository Infos
----------------

    Owners:			Anas Ait-Ali
    				Benjamin BUSINARO
    				Thibault Carpentier
 