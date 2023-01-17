# BIM005 DriveSim

This repo contains code for an FPGA-based driving simulator powered by a 5-stage MIPS-like processor.

The driving simulator features a steering wheel, a gas and brake pedal, and a bluetooth controlled car.

The self-made processor is the central control unit and does most of the data processing. Arduino is used in sensor interfacing and bluetooth data transmission.

![overview](util/project-overview.png)

<p align="center">
  <img src="util/pipeline.jpg" />
</p>

<p align="center">Simplified demonstration of 5-stage processor. Multplication/division and bypass/stall logic not shown. Source: Duke ECE350 lecture slides</p>

<p align="center">
  <img src="util/wheel.png" />
</p>

<p align="center">Steering wheel</p>

<p align="center">
  <img src="util/pedals.png" />
</p>

<p align="center">Foot pedals</p>

<p align="center">
  <img src="util/toy-car.png" />
</p>

<p align="center">Car</p>

See detailed descriptions [here]().