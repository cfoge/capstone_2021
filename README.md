#OENG1168 Assignment 2 2021: Final Report
##FPGA-based video mixer project


Student: **Robert D Jordan S3136906**

Supervisor: **Dr Glen Mathews**

Acknowledgements:

**Lars Larson** (LZX Industries)

**Ed Leckie**

[**https://github.com/cfoge/capstone_2021**](https://github.com/cfoge/capstone_2021)

# Executive summary

#### Introduction

In the research landscape there is a lack of study or documentation
focused on the creation of a digital video mixer designed for the
entertainment and events industry. This creates the need for a project
focused on both the technical realisation of video mixer elements, as
well as the integration of these elements into a single functional
product. In this project an FPGA-based approach was selected as it
allows for iterative design development at low cost. The project uses
the Arty Z7: APSoC Zynq-7000 Development Board from Digilent \[1\]
utilizing the Zynq-7000 SoC \[2\] (Fig 1). This development board was
selected due to existing examples of video applications for the
platform, built-in HDMI ports, and the presence of a hard processor on
silicon.

#### Methodology

This project follows a novel method for development based around the
'On/Off Ramp' method. In this method, branching paths from key
milestones create more confidence of completion through a flexible
design specification. Within each of the key milestones, we followed an
iterative design cycle approach consisting of research, development,
testing and integration of smaller tasks within the overall goal.

#### Test pattern generator

A test-pattern generator with 13 colour test patterns was designed,
built, tested, and deployed to hardware before being integrated into the
final design. These 13 test patterns include a range of colours and
geometric patterns and are used to demonstrate the alpha blender
functionality of the video mixer.

#### Pixel-wise effects

Five visual effects were designed, built, tested, and deployed to
hardware before being integrated into the final design, with several
additional effects developed (but not integrated) into the final design.
These visual effects transform the live incoming video in an
aesthetically pleasing fashion.The HDL designs of these effects perform
well when compared to the mathematical ideal that they derive from.

#### Alpha blender

A 10-bit RGB alpha blender was designed, built, tested, and deployed to
hardware before being integrated into the final design. This module
allows for the alpha blending or mixing of two digital video sources (a
live DVI video source and the test-pattern generator).

#### Auto-fade

An auto-fade module was designed, built, tested, and deployed to
hardware.

#### Interface

A USB UART interface to the alpha blender, test pattern generator and
effects was designed, built, tested, and deployed to hardware before
being integrated into the final design. This design accepts a range of
ASCI commands which it translates to hardware registers via a Xilinx AXI
GPIO IP block. Through this interface test patterns may be selected,
alpha blend position set, and individual effects turned on and off.

#### Conclusion

Developing custom video hardware on FPGA presents a range of challenges.
However, the relatively low cost, high availability of technical
resources and customizable nature of this technology, alongside the huge
potential for parallel processing positions it as a clear choice for
this kind of work over similarly positioned multimedia processors or
general computing systems. This report documents and illustrates some of
the key developments in creating a two-channel digital video mixer
designed for the entertainment industry, along with integrating these
elements into a final working design deployed on hardware.

# Contents {#contents .TOC-Heading}

[Executive summary 2](#executive-summary)

[Glossary of Commonly Used Terms 6](#glossary-of-commonly-used-terms)

[Introduction/Statement of the Problem
7](#introductionstatement-of-the-problem)

[Aims and Achievements 7](#aims-and-achievements)

[Background and Literature Review 8](#background-and-literature-review)

[Methodology/Design and Justification
10](#methodologydesign-and-justification)

[Software and Hardware 10](#software-and-hardware)

[Software 10](#software)

[Hardware 10](#hardware)

[Design Methodology: 10](#design-methodology)

[Simulation Challenges and Solutions
11](#simulation-challenges-and-solutions)

[Test/debug: 12](#testdebug)

[Deployment 14](#deployment)

[Development process 16](#development-process)

[The ON/OFF Ramp Model 16](#the-onoff-ramp-model)

[Timeline 17](#timeline)

[Iterative Development 18](#iterative-development)

[Findings 19](#findings)

[System Design 19](#system-design)

[DVI Video Input and Output 19](#dvi-video-input-and-output)

[DVI to RGB 20](#dvi-to-rgb)

[RGB to DVI 20](#rgb-to-dvi)

[Physical connections 20](#physical-connections)

[The IP Core's Role in Test, Development, and Debug
21](#the-ip-cores-role-in-test-development-and-debug)

[Test Pattern Generator 21](#test-pattern-generator-1)

[Description 21](#description)

[Block Diagram 21](#block-diagram)

[Implementation 21](#implementation)

[Patterns 22](#patterns)

[Summary and Reflection 23](#summary-and-reflection)

[Pixel-wise Effects 23](#pixel-wise-effects-1)

[Metrics for Success 23](#metrics-for-success)

[Description 26](#description-1)

[Pixel-wise Effects System Design 26](#pixel-wise-effects-system-design)

[List of Implemented Video Effects
27](#list-of-implemented-video-effects)

[Mixer/Alpha Blender 34](#mixeralpha-blender)

[Description 34](#description-7)

[Implementation 35](#implementation-4)

[Summary and Reflection 36](#summary-and-reflection-6)

[Auto-fade 36](#auto-fade-1)

[Description 36](#description-8)

[Implementation 37](#implementation-5)

[State Machine diagram 38](#state-machine-diagram)

[Debugging 38](#debugging)

[Summary and Reflection 39](#summary-and-reflection-7)

[Hard Processor Control 39](#hard-processor-control)

[PS to PL bridge using AXI 39](#ps-to-pl-bridge-using-axi)

[UART control 40](#uart-control)

[Additional Exploration 43](#additional-exploration)

[Second HDMI Input 43](#second-hdmi-input)

[Second HDMI Output 44](#second-hdmi-output)

[Resource Utilisation 44](#resource-utilisation)

[Deployed Design 46](#deployed-design)

[Summary and Discussion 46](#summary-and-discussion)

[Recommendations and Future Work 47](#recommendations-and-future-work)

[Frame Buffer 47](#frame-buffer)

[Additional Pixel-wise Effects and Mixing Modes
47](#additional-pixel-wise-effects-and-mixing-modes)

[TCP/IP and UDP control 47](#tcpip-and-udp-control)

[Physical User Interface 48](#physical-user-interface)

[Organisation and Time Management 48](#organisation-and-time-management)

[Conclusion 48](#conclusion-2)

[References 50](#references)

[Appendix 55](#appendix)

[Appendix 1: Milestone Timeline 55](#appendix-1-milestone-timeline)

[Appendix 2: ON/OFF RAMP 56](#appendix-2-onoff-ramp)

# Glossary of Commonly Used Terms

  ----------------------------------- -----------------------------------
  FPGA                                Field programmable gate array

  HDMI/DVI                            **H**igh-**D**efinition
                                      **M**ultimedia
                                      **I**nterface/**D**igital **V**ideo
                                      **I**nterface

  Video Mixer/Vision Switcher         A device for blending multiple
                                      video signals together in real-time

  HDL                                 **H**ardware **D**escriptive
                                      **L**anguage; a specialized
                                      computer language used to describe
                                      the operation of digital logic
                                      circuits

  PL                                  **P**rogrammable **L**ogic; the
                                      FPGA architecture

  PS                                  A hard processor

  IP / IP block / IP Core             IP refers to Intellectual Property
                                      modules written in Verilog or VHDL.
                                      IP is a term for a module or block
                                      of HDL design.

  Synthesize                          The process of transforming a
                                      HDL-specified design into a
                                      gate-level representation.

  RTL                                 **R**egister-**T**ransfer **L**evel
                                      is a design abstraction which
                                      models a synchronous digital
                                      circuit in terms of the flow of
                                      digital signals (data) between
                                      hardware registers, and the logical
                                      operations performed on those
                                      signals.

  JTAG                                JTAG (named after the **J**oint
                                      **T**est **A**ction **G**roup which
                                      codified it) is an industry
                                      standard for verifying designs and
                                      testing printed circuit boards
                                      after manufacture

  AXI                                 **A**dvanced e**X**tensible
                                      **I**nterface, a parallel
                                      high-performance, synchronous,
                                      high-frequency, multi-controller,
                                      multi-agent communication
                                      interface, mainly designed for
                                      on-chip communication.

  ACP                                 **A**ccelerator **C**oherency
                                      **P**ort. An interface enabling
                                      coherent accesses from PL to CPU
                                      memory space
  ----------------------------------- -----------------------------------
