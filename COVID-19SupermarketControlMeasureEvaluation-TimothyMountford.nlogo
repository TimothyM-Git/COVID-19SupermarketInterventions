breed [ people person ]     ; create the breed for customers, referred to as people

breed [ designs design ]    ; create a breed for aesthetic design implements to be placed as turtles

breed [ workers worker ]    ; create the breed for supermarket staff

people-own                  ; characteristics and values for customers
  [ susceptible?            ; if true, the customer is sucseptible with no immunity
    exposed?                ; if true, the customer is exposed and has experienced transmission
    infectious?             ; if true, the customer is infectious and can spread COVID-19
    recovered?              ; if true, the customer has recovered from COVID-19 with aquired immunity
    v1?                     ; if true, the customer has been partially vaccinated
    v2?                     ; if true, the customer has been partially vaccinated
    asymptomatic?           ; if true, the infected customer will present as an asymptomatic case
    personal-prevalence     ; the assigned chance of being infectious related to assigned super-spreader level
    immunity                ; level of immunity required through vaccines or infection
    exposure-period         ; how long a turtle has been exposed to environmental contaminant for
    exposure                ; the cumulative levels of contaminant exposure experienced
    environmental-exposed?  ; if true, the customer is currently exposed to environmental contamination
    social-ss               ; the assigned super-spreader level
    personal-space          ; the assigned social-distance adhered to, factoring for compliance
    destination             ; guides the customer's movement to the next assigned point
    reached-destination?    ; if true, the customer has reached the assigned destination and a new one must be set
    destination-sm-size     ; indicates the number of POIs to be visited in the shop
    reached-destination-sm? ; similar to 'reached-destination?' but defined for supermarket POIs
    shop-queued?            ; if true, the customer has joined the shop queue
    till-queued?            ; if true, the customer has joined the till queue
    queue-position          ; the customers position in the queue
    wait-time               ; indicates the amount of time a customer waits before procedeing
    shopping?               ; if true, the customer has entered the shop
    join-queue?             ; if true, the customer should join the next queue
    head-home?              ; if true, the customer will leave the environment
    serviced?               ; if true, the customer has arrived at a till station
    leave-shop?             ; if true, the customer has finished shopping and will leave the shop
    shop-time               ; cumulative time in the shop
    shopq-time              ; cumulative time in the shop queue
    tillq-time              ; cumulative time in the till queue
    shop-size               ; assigned shopping extent, representative of the number of items to buy


]

workers-own                 ; characteristics and values for staff
  [ susceptible?            ; same as customers
    exposed?
    infectious?
    recovered?
    v1?
    v2?
    house                   ; assigned home location for isolation
    immunity                ; same as customers
    incubation-period
    asymptomatic?
    isolate?                ; if true, the staff member is isolating
    social-ss               ; same as customers
    till-staff?
    exposure-period
    exposure
    environmental-exposed?
    on-leave?               ; if true, the staff member is at home and may be able to work if not isolating

]


patches-own                 ; characteristics for locations
  [  base-color             ; assigned patch colour unaffected by contaminant viewing
     viral-load             ; measure on the level of environmental contaminant in the area
     residential            ; indicates which patches are staff homes
     queue                  ; indicates which patches mark queue locations
     shop                   ; indicates which patches mark POI locations in the shop
     till                   ; indicates which patches mark till locations
     till-free?             ; indicates whether or not the till patches are available for customers
     needs-staff?           ; indicates whether or not the till station is vacant
     staff-spot             ; indicates which patches mark locations to position working staff
  ]

globals                     ; global environment values
  [ social-distance?        ; indication of social distancing implementation
    infect-staff?           ; indication of whether or not staff may be infected (fitting purposes)
    shop-queue              ; no of customers in the shop queue
    till-queue              ; no of customers in the till queue
    shop-capacity           ; no of customers in the allowed in the shop for implementing capacity limiting
    shopq-capacity          ; indication of balking point for the shop queue
    tillq-capacity          ; indication of balking point for the till queue
    till-service-speed      ; multiplier for service time, lower number reflects faster service
    free-tills              ; number of available tills
    day
    hour
    minute
    next-arrival               ; marks the number of mins (ticks) until the next customer arrival
    environmental-infections   ; cumulative transmission countscount
    total-shop-infections
    shop-infections
    shopq-infections
    tillq-infections
    till-infections
    staff-infections
    arrival-rate               ; used to assign customer arrival rates
    shopped                    ; count of customers processed
    shopped1                   ; count of customers processed with a small shop-size
    shopped2                   ; count of customers processed with a medium shop-size
    shopped3                   ; count of customers processed with a large shop-size
    total-shop-time            ; cumulative counts of time spend in each location
    total-shopq-time
    total-tillq-time
    max-shopq-time
    max-tillq-time
    shop-time1                 ; cumulative counts of time as above, devided by shop-size
    shop-time2
    shop-time3
    shopq-time1
    shopq-time2
    shopq-time3
    tillq-time1
    tillq-time2
    tillq-time3
    environmental-fitting      ; fitting parameter for scalling environemental transmission chances
    infected-customers         ; cumulative count of infectious customer arrivals
    susceptible-customers
    infectible-customers
    lost-customers             ; cumulative count of customers lost to balking
    substitute-staff           ; number of staff available to work if other members should isolate
    dissipation-rate           ; decay rate for environmental contamination
    max-shoppers               ; maximum number of customers seen in the shop over a simulated period (used to assign capacity levels)
    crowd-size                 ; number of customers that arrive per arrival time (used for scaling)
    shop-size3                 ; used to assign proportion of customers with large shop-size
    shop-size2                 ; as above for medium shop-size
    as-rel-inf                 ; scalling parameter to reduce the realtive infectiousness of asymptomatic cases
    vax-active?                ; when true, the use of vaccinations is present
    shop-closed?               ; when true, the shop is closed due to no available staff
    shopq-wait                 ; processing time for shop queue, adjusted for sanitization use
    till-wait                  ; wait time for till queue, added wait between customers for till sanitization
    sanitizer-reduction        ; scaling parameter for reducing contaminant loads
]

to setup                       ; environment initialization
  clear-all                    ; clear existing values
  draw-map                     ; setup view visuals
  setup-patches                ; set up patch values
  setup-constants              ; assign and initialise global values
  setup-workers                ; setup staff constants and positions
  update-display               ; update changes in view
  ;univariate-sa               ; used in base model univariate sensitivity analysis for univariate control with Behaviourspace tool

  setup-interventions          ; assign interventions related model changes
  reset-ticks
end

to setup-base                                 ; assign values for base model parameters at base value
  set prevalence 5
  set till-service-speed 3
  set step-size 35
  set dissipation-rate 0.985
  set vax-active? true
  set crowd-size 1
  set shop-size3 10
  set shop-size2 23
  set proportion-asymptomatic 75
  set direct-trans 5
  set as-rel-inf 0.8
  set v1-efficacy 52
  set v2-efficacy 95
  set shop-size-distribution "Base Level"

end

;to univariate-sa                                                  Univariate Sensitivity Analysis Procedure
;  setup-base
;  if usa-parameter = "base" []                  ; usa-parameter indicates the parameter varied
;  if usa-parameter = "prevalence" [
;    if usa-level = "low" [                      ; usa-level indicates the upper or lower bound value assignment
;      set prevalence 2]
;    if usa-level = "high" [
;      set prevalence 10]]
;  if usa-parameter = "till-service-speed" [
;    if usa-level = "low" [
;      set till-service-speed 4]
;    if usa-level = "high" [
;      set till-service-speed 2]]
;  if usa-parameter = "step-size" [
;    if usa-level = "low" [
;      set step-size 20]
;    if usa-level = "high" [
;      set step-size 50]]
;  if usa-parameter = "dissipation-rate" [
;    if usa-level = "low" [
;      set dissipation-rate 0.995]
;    if usa-level = "high" [
;      set dissipation-rate 0.975]]
;  if usa-parameter = "vax-active?" [
;    if usa-level = "low" [
;      set vax-active? false]
;    if usa-level = "high" [
;      set vax-active? true]]
;  if usa-parameter = "shop-size" [
;    if usa-level = "low" [
;      set shop-size3 30
;      set shop-size2 29]
;    if usa-level = "high" [
;      set shop-size3 5
;      set shop-size2 11]]
;  if usa-parameter = "proportion-asymptomatic" [
;    if usa-level = "low" [
;      set proportion-asymptomatic 70]
;    if usa-level = "high" [
;      set proportion-asymptomatic 80]]
;  if usa-parameter = "as-rel-inf" [
;    if usa-level = "low" [
;      set as-rel-inf 0.775]
;    if usa-level = "high" [
;      set as-rel-inf 0.825]]
;  if usa-parameter = "direct-trans" [
;    if usa-level = "low" [
;      set direct-trans 2]
;    if usa-level = "high" [
;      set direct-trans 10]]
;  if usa-parameter = "v1-efficacy" [
;    if usa-level = "low" [
;      set v1-efficacy 30]
;    if usa-level = "high" [
;      set v1-efficacy 67]]
;  if usa-parameter = "v2-efficacy" [
;    if usa-level = "low" [
;      set v2-efficacy 90]
;    if usa-level = "high" [
;      set v2-efficacy 98]]
;
;end



to draw-map
  clear-patches
  clear-turtles

  ask patches
    [ set pcolor 62
      set base-color 62]
  ask patches with [pycor <= 260 and pycor >= 10 and pxcor >= 15 and pxcor <= 365 ] ;;walls
    [ set pcolor 21
      set base-color 21]
  ask patches with [pycor <= 255 and pycor >= 15 and pxcor >= 20 and pxcor <= 360 ] ;;floor
    [ set pcolor 139.5
      set base-color 29]
  ask patches with [pycor <= 260 and pycor > 255 and pxcor >= 30 and pxcor <= 50 ] ;;entrance
    [ set pcolor green
      set base-color green]
  ask patches with [pycor <= 237 and pycor >= 217 and pxcor >= 15 and pxcor < 20 ] ;;exit
    [ set pcolor red
      set base-color red]
  ask patches with [pycor <= 245 and pycor >= 243 and pxcor >= 20 and pxcor <= 45 ] ;;barrier
    [ set pcolor black
      set base-color black]
  ask patches with [pycor <= 260 and pycor >= 203 and pxcor >= 0 and pxcor <= 14 ] ;;side pavement
    [ set pcolor 3
      set base-color 3]
  ask patches with [pycor <= 280 and pycor >= 261 and pxcor >= 0 and pxcor <= 445 ] ;;top pavement
    [ set pcolor 3
      set base-color 3]
  ask patches with [pycor <= 282 and pycor >= 281 and pxcor >= 0 and pxcor <= 445 ] ;;top pavement edge
    [ set pcolor grey
      set base-color grey]
  ask patches with [pycor <= 202 and pycor >= 201 and pxcor >= 0 and pxcor <= 14 ] ;;side pavement edge
    [ set pcolor grey
      set base-color grey]
  ask patches with [pycor <= 282 and pycor >= 281 and pxcor >= 5 and pxcor <= 65 ] ;;trolley gap
    [ set pcolor 2
      set base-color 2]
  ask patches with [pycor <= 360 and pycor >= 283 and pxcor >= 0 and pxcor <= 445 ] ;;tar (road)
    [ set pcolor 0.5
      set base-color 0.5]
  ask patches with [pycor <= 360 and pycor >= 319 and pxcor >= 94 and pxcor <= 94.5 ] ;;paint vertical 1
    [ set pcolor 09.9
      set base-color 09.9]
  ask patches with [pycor <= 318.5 and pycor >= 318 and pxcor >= 44 and pxcor <= 144 ] ;;paint horrizontal 1.1
    [ set pcolor 9.9
      set base-color 9.9]
  ask patches with [pycor <= 336.5 and pycor >= 336 and pxcor >= 44 and pxcor <= 144 ] ;;paint horrizontal 1.2
    [ set pcolor 9.9
      set base-color 9.9]
  ask patches with [pycor <= 354.5 and pycor >= 354 and pxcor >= 44 and pxcor <= 144 ] ;;paint horrizontal 1.3
    [ set pcolor 9.9
      set base-color 9.9]
  ask patches with [pycor <= 360 and pycor >= 319 and pxcor >= 238 and pxcor <= 238.5 ] ;;paint vertical 2
    [ set pcolor 09.9
      set base-color 09.9]
 ask patches with [pycor <= 318.5 and pycor >= 318 and pxcor >= 188 and pxcor <= 288 ] ;;paint horrizontal 2.1
    [ set pcolor 9.9
      set base-color 9.9]
   ask patches with [pycor <= 336.5 and pycor >= 336 and pxcor >= 188 and pxcor <= 288 ] ;;paint horrizontal 2.2
    [ set pcolor 9.9
      set base-color 9.9]
    ask patches with [pycor <= 354.5 and pycor >= 354 and pxcor >= 188 and pxcor <= 288 ] ;;paint horrizontal 2.3
    [ set pcolor 9.9
      set base-color 9.9]
  ask patches with [pycor <= 360 and pycor >= 319 and pxcor >= 382 and pxcor <= 382.5 ] ;;paint vertical 3
    [ set pcolor 09.9
      set base-color 09.9]
  ask patches with [pycor <= 318.5 and pycor >= 318 and pxcor >= 332 and pxcor <= 432 ] ;;paint horrizontal 3.1
    [ set pcolor 9.9
      set base-color 9.9]
  ask patches with [pycor <= 336.5 and pycor >= 336 and pxcor >= 332 and pxcor <= 432 ] ;;paint horrizontal 3.2
    [ set pcolor 9.9
      set base-color 9.9]
  ask patches with [pycor <= 354.5 and pycor >= 354 and pxcor >= 332 and pxcor <= 432 ] ;;paint horrizontal 3.3
    [ set pcolor 9.9
      set base-color 9.9]





  ;; visual Design turtle placement


  ;; Houses

  create-designs 1
   [ setxy 425 238                      ; set location
     set shape "green house"            ; set design shape
     set color 32                       ; set adjustable colour
     set size 45                        ; set size
   ]

  create-designs 1
   [ setxy 425 188
     set shape "green house"
     set color 32
     set size 45
   ]

  create-designs 1
   [ setxy 425 138
     set shape "green house"
     set color 32
     set size 45
   ]

  create-designs 1
   [ setxy 425 88
     set shape "green house"
     set color 32
     set size 45
   ]

  create-designs 1
   [ setxy 425 38
     set shape "green house"
     set color 32
     set size 45
   ]

  ;; Cars

  ;;1

  create-designs 1
   [ setxy 71 360
     set shape "car right"
     set color 9.9
     set size 50
   ]

  create-designs 1
   [ setxy 71 342
     set shape "car right"
     set color 8
     set size 50
   ]

  create-designs 1
   [ setxy 118 360
     set shape "car left"
     set color 6
     set size 50
   ]

  create-designs 1
   [ setxy 118 342
     set shape "car left"
     set color 9.9
     set size 50
   ]

  ;;2

  create-designs 1
   [ setxy 215 360
     set shape "car right"
     set color 9.9
     set size 50
   ]

  create-designs 1
   [ setxy 215 342
     set shape "car right"
     set color 8
     set size 50
   ]

  create-designs 1
   [ setxy 262 360
     set shape "car left"
     set color 9.9
     set size 50
   ]

  create-designs 1
   [ setxy 262 342
     set shape "car left"
     set color 6
     set size 50
   ]

  ;;3

 create-designs 1
   [ setxy 359 360
     set shape "car right"
     set color 6
     set size 50
   ]

  create-designs 1
   [ setxy 359 342
     set shape "car right"
     set color 9.9
     set size 50
   ]

  create-designs 1
   [ setxy 406 360
     set shape "car left"
     set color 9.9
     set size 50
   ]

  create-designs 1
   [ setxy 406 342
     set shape "car left"
     set color 8
     set size 50
   ]

  ;; Trees

  create-designs 1
   [ setxy 377 276
     set shape "flipped accacia tree"
     set color 31
     set size 70
   ]

  create-designs 1
   [ setxy 393 247
     set shape "accacia tree"
     set color 31
     set size 45
   ]

  create-designs 1
   [ setxy 424 190
     set shape "accacia tree"
     set color 31
     set size 65
   ]

  create-designs 1
   [ setxy 385 115
     set shape "flipped accacia tree"
     set color 31
     set size 45
   ]

  create-designs 1
   [ setxy 393 50
    set shape "accacia tree"
     set color 31
     set size 57
   ]

  create-designs 1
   [ setxy 440 25
     set shape "flipped accacia tree"
     set color 31
     set size 45
   ]


  create-designs 1
   [ setxy 93 336
     set shape "car park accacia"
     set color 31
     set size 52
   ]

  create-designs 1
   [ setxy 237 336
     set shape "car park accacia"
     set color 31
     set size 52
   ]

  create-designs 1
   [ setxy 381 336
     set shape "car park accacia"
     set color 31
     set size 52
   ]

  ;; Plants

   create-designs 1
   [ setxy 378 188
     set shape "pincushion pink"
     set color 51
     set size 30
   ]

  create-designs 1
   [ setxy 374 179
     set shape "pincushion orange"
     set color 51
     set size 23
   ]


  create-designs 1
   [ setxy 7 197
     set shape "pincushion pink"
     set color 51
     set size 24
   ]

  create-designs 1
   [ setxy 386 29
     set shape "pincushion pink"
     set color 51
     set size 35
   ]



  ;; Till Designs

  create-designs 1
   [ setxy 35 231
     set shape "till"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 35 191
     set shape "till 2"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 35 151
     set shape "till 3"
     set color 31
     set size 15
   ]



  ;; Islands

   create-designs 1
   [ setxy 115 200
     set shape "fruit island"
     set color 31
     set size 37
   ]

  create-designs 1
   [ setxy 220 200
     set shape "veggie island"
     set color 28
     set size 37
   ]

   create-designs 1
   [ setxy 133 100
     set shape "starch shelf"
     set color 48
     set size 35
   ]

   create-designs 1
   [ setxy 100 100
     set shape "nonperishable shelf"
     set color 31
     set size 35
   ]

  create-designs 1
   [ setxy 267 100
     set shape "middle freezer"
     set color 4
     set size 35
   ]

  create-designs 1
   [ setxy 234 100
     set shape "middle freezer green"
     set color 4
     set size 35
   ]

  create-designs 1
   [ setxy 201 100
     set shape "mystery freezer"
     set color 4
     set size 35
   ]

  ;; Shelves

  create-designs 1
   [ setxy 49 229
     set shape "empty queue shelf"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 223
     set shape "empty queue shelf 3"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 217
     set shape "empty queue shelf 2"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 211
     set shape "empty queue shelf"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 205
     set shape "empty queue shelf 3"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 199
     set shape "empty queue shelf 2"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 193
     set shape "empty queue shelf 5"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 187
     set shape "empty queue shelf"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 181
     set shape "empty queue shelf 2"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 175
     set shape "empty queue shelf 5"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 169
     set shape "empty queue shelf 3"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 163
     set shape "empty queue shelf 2"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 157
     set shape "empty queue shelf"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 151
     set shape "empty queue shelf"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 145
     set shape "empty queue shelf 3"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 139
     set shape "empty queue shelf 2"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 133
     set shape "empty queue shelf 2"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 127
     set shape "empty queue shelf 5"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 49 121
     set shape "empty queue shelf"
     set color 31
     set size 15
   ]

  create-designs 1
   [ setxy 34 122
     set shape "plain top shelf 4"
     set color 31
     set size 34
   ]

   create-designs 1
   [ setxy 35 85
     set shape "bath shelf"
     set color 31
     set size 36
   ]

  create-designs 1
   [ setxy 35 45
     set shape "cleaning shelf"
     set color 31
     set size 36
   ]


  create-designs 1
   [ setxy 170 50
     set shape "prepared food 1"
     set color 2
     set size 52
   ]

  create-designs 1
   [ setxy 115 50
     set shape "prepared food 2"
     set color 2
     set size 52
   ]

  create-designs 1
   [ setxy 339 30
     set shape "fridge back 2"
     set color 3
     set size 30
   ]

  create-designs 1
   [ setxy 304 30
     set shape "fridge back 2"
     set color 3
     set size 30
   ]

  create-designs 1
   [ setxy 269 30
     set shape "fridge back 2"
     set color 3
     set size 30
   ]

  create-designs 1
   [ setxy 234 30
     set shape "fridge back 2"
     set color 3
     set size 30
   ]

   create-designs 1
   [ setxy 340 112
     set shape "liquid fridge"
     set color gray
     set size 28
   ]

   create-designs 1
   [ setxy 340 142
     set shape "sweet fridge"
     set color 49
     set size 28
   ]

   create-designs 1
   [ setxy 340 172
     set shape "veggie fridge"
     set color 72
     set size 28
   ]

  create-designs 1
   [ setxy 340 202
     set shape "dairy fridge"
     set color 48
     set size 28
   ]

  create-designs 1
   [ setxy 340 82
     set shape "wine fridge"
     set color 51
     set size 28
   ]

  create-designs 1
   [ setxy 294 244
     set shape "bread shelf 1"
     set color 28
     set size 32
   ]

  create-designs 1
   [ setxy 320 232
     set shape "egg shelf"
     set color 2
     set size 28
   ]

  create-designs 1
   [ setxy 272 258
     set shape "cereal shelf"
     set color 31
     set size 50
   ]


  create-designs 1
   [ setxy 227 258
     set shape "chip shelf"
     set color 31
     set size 50
   ]

  create-designs 1
   [ setxy 153 248
     set shape "plant shelf"
     set color 36
     set size 36
   ]

  create-designs 1
   [ setxy 186 255
     set shape "chocolate shelf"
     set color 31
     set size 44
   ]

ask designs with [shape = "car right" or shape = "car left"] [set hidden? true]          ; hide car placements to allows changes in cars seen over time


end

to update-visibility
  ifelse random 20 < count people [set hidden? false][set hidden? true]           ; change the proportion of cars visable according to no. of customers present
end

to setup-patches                    ; assign patch locations and base values
  ask patches
  [ set till-free? false            ; all patches will have this characteristic, only till locations should be marked as available
    set viral-load 0                ; initialise contaminant levels
  ]

  ask patches with [pxcor =  35 and pycor =  269] [set queue 1]               ; assign location of shop queue
  ask patches with [pxcor =  60 and pycor =  225] [set queue 2]               ; assign location of till queue
  ask patches with [pxcor =  115 and pycor =  200] [set shop 1]               ; assign location of shop POIs
  ask patches with [pxcor =  220 and pycor =  200] [set shop 1]
  ask patches with [pxcor =  325 and pycor =  200] [set shop 1]
  ask patches with [pxcor =  115 and pycor =  100] [set shop 1]
  ask patches with [pxcor =  220 and pycor =  100] [set shop 1]
  ask patches with [pxcor =  325 and pycor =  100] [set shop 1]
  ask patches with [pxcor =  35 and pycor =  153] [set till-free? true]       ; assign availability of till stations
  ask patches with [pxcor =  35 and pycor =  233] [set till-free? true]
  ask patches with [pxcor =  35 and pycor =  193] [set till-free? true]
  ask patches with [pxcor =  35 and pycor =  150] [set needs-staff? 0]       ; assign status of till vacancy (1 vacant; 0 manned)
  ask patches with [pxcor =  35 and pycor =  230] [set needs-staff? 0]
  ask patches with [pxcor =  35 and pycor =  190] [set needs-staff? 0]
  ask patches with [pxcor =  35 and pycor =  150] [set staff-spot 1]         ; assign locations for staff to stand behind tills
  ask patches with [pxcor =  35 and pycor =  230] [set staff-spot 1]
  ask patches with [pxcor =  35 and pycor =  190] [set staff-spot 1]
  ask patches with [pxcor =  35 and pycor =  153] [set till 1]               ; assign location of tills
  ask patches with [pxcor =  35 and pycor =  233] [set till 1]
  ask patches with [pxcor =  35 and pycor =  193] [set till 1]
  ask patches with [pxcor =  411 and pycor =  27] [set residential 1]        ; assign location of staff homes
  ask patches with [pxcor =  411 and pycor =  77] [set residential 2]
  ask patches with [pxcor =  411 and pycor =  127] [set residential 3]
  ask patches with [pxcor =  411 and pycor =  177] [set residential 4]
  ask patches with [pxcor =  411 and pycor =  227] [set residential 5]

end

;; This sets up basic constants of the model.
to setup-constants
  set shop-capacity 2000                         ; Much larger than will be reached, adjusted for Capacity Limiting Scenarios
  set shopq-capacity 40                          ; balking if shop queue = 40 (before extending outside of environment)
  set tillq-capacity 20                          ; balking if till queue = 20
  set infect-staff? true                           ; initialise global parameters mentioned above
  set free-tills count patches with [till-free?]
  set day 1
  set hour 7
  set minute 0
  set next-arrival 0
  set environmental-infections 0
  set total-shop-infections 0
  set shop-infections 0
  set shopq-infections 0
  set tillq-infections 0
  set till-infections 0
  set staff-infections 0
  set shopped 0
  set total-shop-time 0
  set shopped1 0
  set shopped2 0
  set shopped3 0
  set max-shoppers 0
  set max-shopq-time 0
  set max-tillq-time 0
  set total-shopq-time 0
  set total-tillq-time 0
  set shop-time1 0
  set shop-time2 0
  set shop-time3 0
  set shopq-time1 0
  set shopq-time2 0
  set shopq-time3 0
  set tillq-time1 0
  set tillq-time2 0
  set tillq-time3 0
  set environmental-fitting 1
  set infected-customers 0
  set susceptible-customers 0
  set infectible-customers 0
  set lost-customers 0
  set shop-closed? false
  set substitute-staff 2
  ifelse till-service = "Slower" [set till-service-speed 4][ifelse till-service = "Faster" [set till-service-speed 2][set till-service-speed 3]]
  set dissipation-rate (1 - (contaminant-dissipation / 100))
  set crowd-size 1
  ifelse shop-size-distribution = "More Small Shops" [
    set shop-size3 5
    set shop-size2 11][
    ifelse shop-size-distribution = "Fewer Small Shops" [
      set shop-size3 30
      set shop-size2 29][
      set shop-size3 10
      set shop-size2 23]]
  set as-rel-inf (asym-relative-inf / 100)
  if use-base-levels? [setup-base]
  ifelse vaccine-scenario = "No Vaccines" [set vax-active? false][set vax-active? true]

end


to setup-workers                 ; initialise staff characteristics and locations
  create-workers 1
   [ setxy 310 - 275 150
     set house 1
     set on-leave? false
   ]
  create-workers 1
   [ setxy 310 - 275 190
     set house 2
     set on-leave? false
   ]
  create-workers 1
   [ setxy 310 - 275 230
     set house 3
     set on-leave? false
   ]
  create-workers 1
   [ setxy 411 177
     set house 4
     set on-leave? true
   ]
  create-workers 1
   [ setxy 411 227
     set house 5
     set on-leave? true
   ]


  ask workers [
    set till-staff? true
    set size 12
    set incubation-period 0
    set environmental-exposed? false
    set isolate? false
    set social-ss 50
    set exposure 0
    set exposure-period 0
    ; assign vaccination status
    ifelse vaccine-scenario = "Staff Vaccine Mandate" or vaccine-scenario = "Full Vaccine Mandate" [get-fully-vax][get-susceptible]
    set shape "better shaped till person"]
end

to setup-interventions

  ifelse vaccine-scenario = "No Vaccines" [set vax-active? false][set vax-active? true]
  ifelse capacity-limit = "75%" [set shop-capacity 15][
    ifelse capacity-limit = "50%" [set shop-capacity 10][set shop-capacity 2000]]
  ifelse sanitization = "None" [ ; no sanitization
    set shopq-wait 1
    set till-wait 1] [
    ; Sanitizer in use

  create-designs 1             ; place visual design of entrance sanitizer
   [ setxy 33 260
     set shape "sanitiser"
     set color 31
     set size 22
   ]
    ifelse sanitization = "Entrance" [                               ; adjust process times for entrance and till sanitization
      set sanitizer-reduction (sanitizer-disinfection / 100)
      set shopq-wait 2
      set till-wait 1] [
      set sanitizer-reduction (sanitizer-disinfection / 100)
      set shopq-wait 2
      set till-wait 2]]




end



to update-display      ; update visualisation of environmental contamination
  ask patches
    [ if pcolor != base-color [
      if viral-load = 0 [set pcolor base-color]]
      if viral-load > 0 [set pcolor scale-color yellow viral-load 100 0]] ; scale color to be darker for higher contaminant load
end

to update-time         ; update procedures for incrementing time
  ifelse minute = 50 [      ; Hourly Procedures
    set minute 0
    ask designs with [shape = "car right" or shape = "car left"] [update-visibility]    ; change the proportion of cars visable hourly
    ifelse hour = 20 [      ; Daily Procdures
      ;ask patches with [
      progress-disease      ; Update disease progression for staff
      if staff-testing = "Daily" [ask workers with [not on-leave?] [get-tested]]        ; test staff for COVID-19 if implemented daily
      ifelse count workers with [on-leave?] = 5 [set shop-closed? true][if shop-closed? [set shop-closed? false]] ; Close shop if no staff available
      set next-arrival round random-exponential 4   ; set arrival for next customer at first time-period rate
      set hour 7
      set day day + 1][set hour hour + 1]][set minute minute + 10]
  if hour < 12 [set arrival-rate 4]                    ; adjust customer inter-arrival rates for related time-periods
  if hour >= 12 and hour < 14 [set arrival-rate 2]
  if hour >= 14 and hour < 17 [set arrival-rate 3]
  if hour >= 17 and hour < 19 [set arrival-rate 1]
  if hour >= 19 [set arrival-rate 200]                 ; minimal chance of arrival for staff to close-shop

  if staff-testing = "Weekly" [        ; test staff for COVID-19 if implemented weekly
    if day = 3 or day = 10 [ask workers with [not on-leave?] [get-tested]]]

end

to go                                                                      ; Procedures run at each min time increment (tick)
  if count people > 0 [
  ask people [
      if not infectious? [if not exposed? [check-contaminants]]            ; Receptive customers check contaminant exposure
    ifelse till-queued? [move-tillq][                                      ; Call movement procedures for customers
      ifelse shop-queued?[move-shopq][
        ifelse shopping?[move-shop][
          move]]]

  ]]
  ifelse next-arrival = 0 [birth][set next-arrival next-arrival - 1]       ; Adjust time until next customer arrival or initialize customer arrival (birth) at 0

  ask workers [ifelse infectious? [                                            ; Allow infectious staff to spread enivironmental contamination
    spread-virus][if infect-staff? [if not exposed? [check-contaminants]]]]    ; Receptive staff check contaminant exposure
  ask people with [infectious?] [
    infect-or-fail                                                         ; Allow infectious customers to attempt direct transmission with others
    spread-virus]                                                          ; Allow infectious customers to spread enivironmental contamination
  if ticks mod 10 = 0 [                                ; (done every 10 min to speed up simulation runtime)
    if view-contamination? [update-display]            ; Update display of environmental contamination
    update-time                                        ; 10 min time increment

  ]

  if count people with [shopping?] > max-shoppers [set max-shoppers count people with [shopping?]] ; adjust maximum customers seen in shop if applicable
  ask people with [shopping?] [set shop-time shop-time + 1]                 ; Increment time counts for customer processes
  ask people with [shop-queued?] [set shopq-time shopq-time + 1]
  ask people with [till-queued?] [set tillq-time tillq-time + 1]
  ask patches with [viral-load > 0][dissipate]                              ; Allow decay/dissipation of environmental contaminants
  tick
end

to birth                                       ; Set up customer on arrival
  create-people crowd-size                                ; Create the assigned number of customers
    [ setxy 35 275                                        ; Arrival location

      set exposure-period 0                               ; Initialize period of contaminant exposure
      set-ss-level                                        ; Call procedure to assign Super-Spreader level according to contact profiles
      set reached-destination? false                      ; Initialize to indicate movement towards next destination
      set destination one-of patches with [queue = 1]     ; Set destination as shop queue/entrance
      set reached-destination-sm? true                    ; Initialise operation states
      set shop-queued? false
      set till-queued? false
      set queue-position 0
      set wait-time 0
      set shopping? false
      set join-queue? true                                ; Set indicattion to join the queue on arrival
      set head-home? false
      set serviced? false
      set leave-shop? false
      set shop-time 0                                     ; Initialise time counting variables
      set shop-time 0
      set shopq-time 0
      set tillq-time 0
      set shop-size 0
      set environmental-exposed? false
      set exposure 0
      set exposure-period 0
      ; Procedure to assign individual social distancing compliance extents
      ifelse social-distancing? [
        ifelse social-ss > 50 [
          ifelse social-ss > 80 [set personal-space (6 - random 4)][   ; If very high super-spreader level, chance for full to no compliance
          set personal-space (6 - random 3)]][                         ; If high super-spreader level, chance for full to 33% compliance
        set personal-space 6]][                                        ; Full compliance for other super-spreader levels
        set personal-space 3]                                          ; Personal space adherance with no social distancing
      set size 12  ;; easier to see
      ifelse vax-active? [
      ; Procedure to assign vaccination states
      ifelse vaccine-scenario = "Full Vaccine Mandate" [ifelse random-float 100 < personal-prevalence [get-infectious][get-fully-vax]][   ; Set non-infectious customers as fully vaccinated at full mandate
      ifelse random-float 100 < personal-prevalence [get-infectious][           ; Set infectiousness based on contact-adjusted rates
        ifelse random-float (100 - personal-prevalence) < v2-coverage [get-fully-vax][   ; Set full vaccination status based on coverage rates
            ifelse random-float (100 - personal-prevalence - v2-coverage) < (v1-coverage - v2-coverage) [get-vax][get-susceptible]]  ]  ]][   ; Set part vaccination status based on coverage rates
      ifelse random-float 100 < personal-prevalence [
      get-infectious ][
        get-susceptible] ]  ; Remainder as suceptible
      if shape != "person" [ set shape "person" ]     ; Set color according to disease state
      set color ifelse-value susceptible? [ green ] [ ifelse-value exposed? [ yellow ] [ ifelse-value infectious? [ red ][ ifelse-value recovered? [ white ][ ifelse-value v1? [ cyan ][ blue ] ] ] ] ]


  ]
  set next-arrival round random-exponential arrival-rate    ; Assign time to next arrival
end

to set-ss-level                                                            ; Procedure to assign contact related super-spreader level and associated likelihood of being infectious
  ifelse ss-distribution = "More Contacts" [                               ; From Contact profile sources, distribution with higher mean contact counts
    let rand random 101
    ifelse rand <= 40 [set social-ss 20][                                  ; Set super-spreader level according to indicated proportions (Minimal)
      ifelse rand <= 70 [set social-ss 40][                                ; (Low)
        ifelse rand <= 85 [set social-ss 60][                              ; (Medium)
          ifelse rand <= 95 [set social-ss 80][set social-ss 100]]]]       ; (High) / (Very High)
    set personal-prevalence (prevalence * (social-ss / 20 * 0.4762))][     ; Assign chances of being infectious at ratios of 1:2:3:4:5 for each SS level, chances given as a proportion of
                                                                           ; the allocated population prevalence level such that the assigned prevalence is unchanged. The decimal number
                                                                           ; shown is a scaling factor to adjust for the interactions between the distribution of SS levels and the proportional
                                                                           ; increase in the chance ratios, allowing these interactions to sum to 1
    ifelse ss-distribution = "Fewer Contacts" [                            ; From Contact profile sources, distribution with lower mean contact counts
      let rand random 101
      ifelse rand <= 60 [set social-ss 20][
        ifelse rand <= 85 [set social-ss 40][
          ifelse rand <= 93 [set social-ss 60][
            ifelse rand <= 98 [set social-ss 80][set social-ss 100]]]]
      set personal-prevalence (prevalence * (social-ss / 20 * 0.6098))][
      let rand random 101                                                  ; From Contact profile sources, remaining distribution of contact counts
      ifelse rand <= 50 [set social-ss 20][
        ifelse rand <= 80 [set social-ss 40][
          ifelse rand <= 90 [set social-ss 60][
            ifelse rand <= 95 [set social-ss 80][set social-ss 100]]]]
      set personal-prevalence (prevalence * (social-ss / 20 * 0.5405))]]

end

;----------------- MOVEMENT Procedures ------------------------------

to move ;; turtle procedure                                 movement procedure for customers outside the shop and queues (mostly to approach the shop)
  ifelse wait-time > 0 [
  rt random 101
  lt random 101
  fd 1
  set wait-time wait-time - 1]
  [
    ifelse reached-destination? [
      ifelse join-queue? [join-queue][
        set wait-time 15]

    ]
    [
      ifelse distance destination > 3 [
        face destination

        forward 4
      ]
      [
        set reached-destination? true

      ]
    ]
  ]
end

to move-shopq                                                                          ; Movement Procedure within the shop queue
  ifelse wait-time > 0 [set wait-time wait-time - 1][                                  ; If waiting only decrease wait time
    ifelse queue-position = 1 [                                                        ; For the customer at the front of the queue
      ifelse count people with [ shopping? ] < shop-capacity [                         ; If the shop is not at capacity
        set shop-queue shop-queue - 1                                                  ; The customer will enter the shop, so decrease length of queue
        set shop-queued? false                                                         ; Change states from queued in the shop to shopping
        set shopping? true
        set destination one-of patches with [pycor =  250 and pxcor =  45]             ; Set destination to move into the shop
        set reached-destination? false
        set queue-position queue-position - 1                                          ; Set queue position back to 0
        if count people with [shop-queued?] > 0 [                                      ; If there are other people in the queue,
        ask people with [shop-queued?] [
          set queue-position queue-position - 1]                                       ; Decrease their queue-position by one
        ask one-of people with [shop-queued? and queue-position = 1] [                 ; Ask the next person to be first in the queue,
          set destination one-of patches with [pycor =  269 and pxcor =  45]           ; To aim to move towards the front of the queue
          set wait-time shopq-wait]]]                                                  ; Allocate processing time to wait for sanitization etc
      [set wait-time wait-time + 1]                                                    ; If the shop is at capacity, then continue to wait
  ][
      let spot queue-position                                                          ; For the other customers in the queue
      let space personal-space
      let last-x 45           ; Front of queue x coordinate
      let last-y 269          ; Front of queue y coordinate
      ask one-of people with [shop-queued? and queue-position = spot - 1] [            ; Find out where the customer ahead is/ is heading to
        ask destination [
          set last-x pxcor
          set last-y pycor]]
      set destination one-of patches with [pxcor = last-x + space and pycor = 269]]]   ; Aim to be their assigned personal social-distance behind that
                                                                                       ; Destinations based on other customer destinations, to prevent incorrect positioning when customers are moving
  if distance destination > 0 [                                                        ; If the customer isn't at their assigned queue position (location)
    face destination
    ifelse distance destination > 15 [forward 10][forward 2]]                          ; Move forward in the queue, moving faster if the gap ahead is large enough
  if count people with [shop-queued? and queue-position = 1] = 0 [                     ; If no customers are first in the queue, the person in second moves to the front of the queue
    ask people with [shop-queued?] [
          set queue-position queue-position - 1
          set wait-time 1]]

end

to move-tillq                                                                          ; Movement Procedure within the shop queue
  ifelse wait-time > 0 [set wait-time wait-time - 1][                                  ; If waiting only decrease wait time
    if distance destination > 0 [                                                      ; If the customer isn't at their assigned queue position (location)
    face destination
        ifelse distance destination > 25 [forward 20][forward 6]]]                     ; Move forward in the queue, moving faster if the gap ahead is large enough
    ifelse queue-position = 1 [                                                        ; For the customer at the front of the queue
      ifelse free-tills > 0 [                                                          ; If there are any till stations available,
        set till-queue till-queue - 1                                                  ; The customer move to the till, so decrease length of queue
        move-to one-of patches with [till-free?]                                       ; Move to an available till
        if till = 1 [set till-free? false]                                             ; when they're at the till, make it unavailable
        set free-tills free-tills - 1                                                  ; decrease the number of till stations available
        set till-queued? false                                                         ; Change state from being in the till queue to being serviced
        set serviced? true
        set wait-time random-poisson shop-size * till-service-speed                    ; Assign a processing time proportional to the shop-size
        set queue-position queue-position - 1                                          ; set queue-position to 0
        if count people with [till-queued?] > 0 [                                      ; If other customers are in the till queue, they move forward in position
        ask people with [till-queued?] [
          set queue-position queue-position - 1]
        ask one-of people with [till-queued? and queue-position = 1] [                 ; Tell the next person in the front of the queue to move towards the front of the queue
          set destination one-of patches with [pycor =  233 and pxcor =  35]
          set wait-time 1]]]
      [set wait-time wait-time + 1]]
  [ let spot queue-position
    let space personal-space
    let last-x2 55                                                                     ; Movement for other customers in the queue similar to shop queue
    let last-y2 233
    ask one-of people with [till-queued? and queue-position = spot - 1] [
      ask destination [
        set last-x2 pxcor
        set last-y2 pycor]]
    ifelse last-y2 > 60 [
      set destination one-of patches with [pxcor = 55 and pycor = last-y2 - (space + 3)]] [          ; When the till queue extends downward towards the end of the shop, start queuing to the right
      set destination one-of patches with [pxcor = last-x2 + (space + 3) and pycor = last-y2]]]


end

to move-shop                                                                                     ; Procedures for movement in the shopping area and till space
  ifelse serviced? [                                                                             ; for those at a till station
    ifelse wait-time > 0 [
      if wait-time mod 3 = 0 [ask workers in-radius 5 with [infectious?] [infect-or-fail]]       ; Regularly allow for direct transmission between staff and customer while in service
      set wait-time wait-time - 1                                                                ; Decrease allocated service time
      ][                                                                                         ; on completion of service time,
      ask workers in-radius 5 with [infectious?] [infect-or-fail]
      set serviced? false                                                                        ; indicate completed service
      set destination one-of patches with [pycor =  235 and pxcor =  15]                         ; aim to move to shop exit
      set leave-shop? true                                                                       ; indicate intention to leave the shop
      set free-tills free-tills + 1                                                              ; increase number of available tills
      ask patches in-radius 6 [if till = 1 [set till-free? true ]]                               ; indicate till availability
      if sanitization = "Entrance and Tills" [ask patches in-radius 10 [if viral-load > 0 [set viral-load viral-load * sanitizer-reduction]]] ; if sanitization at the tills, decrease contaminant level
      if count people with [till-queued?] > 0 [
        ask one-of people with [till-queued? and queue-position = 1][set wait-time till-wait]]   ; if there is a customer waiting to move to the till, indicate waiting period for sanitization
      ]][
  if wait-time < 1 [                                                 ; For customers not at a till station
  ifelse destination-sm-size > 0 [                                   ; if they need to still collect more items (visit more points)
    ifelse distance destination > step-size - 1 [                    ; and they haven't reached their current allocated point
      face destination                                               ; move towards the POI
      fd step-size][
      set destination-sm-size destination-sm-size - 1                ; if they have reached the point, reduce the number of items to collect (points to visit)
      set destination one-of patches with [shop = 1]]][              ; select another POI to collect from
    ifelse distance destination > step-size - 1 [                    ; if they don't still have to collect items and haven't reached their destination
      face destination
      fd step-size][                                                 ; move towards their destination
      ifelse join-queue? [join-till-queue][                          ; if they're moving to the queue and should join the queue, initiate those steps
      ifelse leave-shop? [leave-shop][                               ; if they're moving to the exit and should leave the shop, initiate those steps
        set destination one-of patches with [queue = 2]              ; otherwise they were collecting their last item and should not move to join the queue
              set join-queue? true]]]]]]




end


to join-queue                                                                                  ; Procedures to join the shop queue
  ifelse shop-queue < shopq-capacity and till-queue < tillq-capacity and not shop-closed? [    ; if the shop is open and the queues aren't too long
    set queue-position shop-queue + 1                                                          ; Join the back of the queue
    if shop-queue = 0 [set wait-time 1]                                                        ; If there is nobody queued, indicate entry processing time
    set shop-queue shop-queue + 1                                                              ; Increase the number of people in the queue
    set shop-queued? true                                                                      ; Indicate queued state
    let spot queue-position
    let space personal-space
    ifelse spot = 1 [                                                                          ; as with queue movement, join the queue at the assigned personal space behind the last person queued
      set ycor 269
      set xcor 45 + (personal-space * spot)
      set destination one-of patches with [pxcor = 45 + (space * spot) and pycor = 269]] [
      let last-x 45
      let last-y 269
      ask one-of people with [shop-queued? and queue-position = spot - 1] [                    ; by finding out where they're aiming to queue
        ask destination [
          set last-x pxcor
          set last-y pycor]]
      ifelse last-x > 415 [set xcor 415 + personal-space][set xcor last-x + personal-space]    ; and moving behind them, do not moved outside of the simulation space when the queue is long
      set ycor last-y
      set destination one-of patches with [pxcor = last-x + space and pycor = 269]]
    set join-queue? false                                                                      ; No longer indicate a need to join the queue
    set size 12
    ifelse random 101 <= shop-size3 [                                                          ; Allocate the customer's intended shop-size
      set destination-sm-size 4                                                                ; and associated number of items to collect (POIs to visit)
      set shop-size 3][                                                                        ; for Large
      ifelse random 101 < shop-size2 [
        set destination-sm-size 2
        set shop-size 2][                                                                      ; Medium
        set destination-sm-size 1
        set shop-size 1]]                                                                      ; and Small shop-sizes
    if shop-queue = 0 [set wait-time 1]                                                        ; if they're the first to join the queue, indicate processing time
   ][
    set lost-customers lost-customers + 1                                                      ; If the queues are too long, or the shop is closed, add to the count of lost customers
    die                                                                                        ; and leave the environment
   ]

end

to join-till-queue                                                                                 ; In procedures to join the Till Queue
    set queue-position till-queue + 1                                                              ; set position to one more than the number of people in the queue
    set till-queue till-queue + 1                                                                  ; increase the number of people queued
    set till-queued? true                                                                          ; Indicate queuing status
    let spot queue-position                                                                        ; As seen in joining the shop queue,
    let space personal-space
    ifelse spot = 1 [                                                                              ; If first in queue, move to the front of the queuing area
      set ycor 233
      set xcor 55
      set destination one-of patches with [pxcor = 55 and pycor = 233]] [                          ; and indicate the intention to be there, otherwise
      let last-x2 55
      let last-y2 233
      ask one-of people with [till-queued? and queue-position = spot - 1] [                        ; Find out the expected position of the person queued ahead
        ask destination [
          set last-x2 pxcor
          set last-y2 pycor]]
      ifelse last-y2 > 60 [                                                                        ; and move behind them in the queue
        set xcor last-x2
        set ycor last-y2 - (personal-space + 3)
        set destination one-of patches with [pxcor = 55 and pycor = last-y2 - (space + 3)]] [      ; customers queue downwards untill reaching environment limits
        set xcor last-x2 + (personal-space)
        set ycor last-y2
        set destination one-of patches with [pxcor = last-x2 + (space + 3) and pycor = last-y2]]]  ; then start queuing to the right
    set join-queue? false

end

to leave-shop                                                      ; Procedures to leave the shop
  set shopping? false                                              ; Indicate the person is no longer shopping
  set leave-shop? false                                            ; No longer need to indicate intention to leave
  set shopped shopped + 1                                          ; Increase the number of customers processed
  set total-shop-time total-shop-time + shop-time                  ; Add individual times recorded to the total aggregated counts
  set total-shopq-time total-shopq-time + shopq-time
  set total-tillq-time total-tillq-time + tillq-time
  if shopq-time > max-shopq-time [set max-shopq-time shopq-time]   ; If any queue times were longer than preceding customers, update max times
  if tillq-time > max-tillq-time [set max-tillq-time tillq-time]
  if shop-size = 1 [                                               ; Also add counts to aggregates grouped by shop-size
    set shopped1 shopped1 + 1
    set shop-time1 shop-time1 + shop-time
    set shopq-time1 shopq-time1 + shopq-time
    set tillq-time1 tillq-time1 + tillq-time]
  if shop-size = 2 [
    set shopped2 shopped2 + 1
    set shop-time2 shop-time2 + shop-time
    set shopq-time2 shopq-time2 + shopq-time
    set tillq-time2 tillq-time2 + tillq-time]
  if shop-size = 3 [
    set shopped3 shopped3 + 1
    set shop-time3 shop-time3 + shop-time
    set shopq-time3 shopq-time3 + shopq-time
    set tillq-time3 tillq-time3 + tillq-time]
  set shop-time 0
  set size 4
  die                                                               ; Remove from environment
end

to infect-or-fail                                        ; Direct transmission procedure
    ifelse asymptomatic? [                               ; for asymptomatic cases,
      if random 101 < (direct-trans * as-rel-inf) [      ; at the chance of direct transmission adjusted for the relative infectiousness of asymptomatic cases
      ask people in-radius 5 [                           ; Attempt transmission with any individuals in contact
        if random 101 > immunity [get-sick] ]]           ; They become exposed at rates accounting for aquired/vaccine related immunity
  ][
    if random 101 < direct-trans [                       ; as above, but at rates unadjusted for asymptomatic cases
    ask people in-radius 5 [
        if random 101 > immunity [get-sick] ]]
  ]
end

to check-contaminants                                             ; Procedure for Receptive individuals to allow for environmental transmission
  if viral-load > 0 [                                             ; If the current location has contamination
    set environmental-exposed? true                               ; Indicate current exposure to contaminant
    set exposure-period exposure-period + 1                       ; increase the indication of the amount of time exposed to contaminant
    set exposure exposure + viral-load                            ; increase the aggregate value of the contaminant levels exposed to
    if exposure-period mod 5 = 0 [environmental-transmission]]    ; for every 5 min of exposure, allow for the chance of environmental transmission (for long period of exposure)
  if environmental-exposed? [                                     ; If indicated to be exposed to contaminant
    if viral-load = 0 [                                           ; and the current location has no contamination
      environmental-transmission                                  ; allow a final chance of transmission (important for shorted exposure-periods < 5)
      set environmental-exposed? false                            ; reset contaminant exposure parameters
      set exposure-period 0
      set exposure 0]]


end

to environmental-transmission                                     ; Procedure for when environmental transmission may occur
  let trans-chance  13
  let avg-exposure  (exposure / exposure-period)                  ; determine the average contaminant level exposed to over the period of exposure
  if exposure-period > 5 [set trans-chance 15]                    ; longer periods of exposure result in increased chances of transmission
  if exposure-period > 15 [set trans-chance 17]
  set trans-chance round (trans-chance * avg-exposure * environmental-fitting / 100) ; determine chance of infection by adjusting for the average exposure intensity
  if random 1001 <= trans-chance [if random 101 > immunity [
    set environmental-infections environmental-infections + 1     ; Allow transmission at these rates, factoring for immunity, increase the aggregated count of environmental transmissions
    get-sick]]

end

to spread-virus                                                   ; Procedure for infectious individuals to spread environmental contamination
ifelse sanitization != "None" and social-ss < 81 and shopping? [  ; When there is sanitizer at the entrance, those who would comply and have entered the shop (having sanitized their hands)
    ifelse asymptomatic? [                                        ; the amount of environmental contamination is reduced by the reduction from sanitizer use
      ask patches in-radius 3 [set viral-load 100 * as-rel-inf * sanitizer-reduction]][   ; this is further reduced for the relative infectiousness of asymptomatic cases
      ask patches in-radius 3 [set viral-load 100 * sanitizer-reduction]]] [              ; Increasing the contaminant viral load of the areas they com in contact with
    ifelse asymptomatic? [
      ask patches in-radius 3 [set viral-load 100 * as-rel-inf]][ ; Those who don't use sanitizer or before having the opportunity to do so, will spread contamination at the regular level
      ask patches in-radius 3 [set viral-load 100]]]              ; still adjusted for the relative infectiousness of asymptomatic cases

end

to dissipate    ; at each time-step, the viral load of environmental contamination will dissipate at the assigned rate, becoming inactive at low enough levels.
  ifelse viral-load > 20 [set viral-load viral-load * dissipation-rate][set viral-load 0]

end

to progress-disease                                                   ; Procedures for progressing COVID-19 infections in staff members
  ask workers with [exposed? or infectious?] [                        ; Those who are infected
  set incubation-period incubation-period + 1                         ; increase the indication of time since exposure
  if incubation-period = 2 [
      get-infectious]                                                 ; after two days, those in the Exposed state become infectious

    if incubation-period = 7  [                                       ; 5 days later symptomatic cases will develop symptoms
      ifelse asymptomatic? [][                                        ; asymptomatic cases will not
        set on-leave? true                                            ; if symptoms develop, the staf member is required to isolate, indicating they are not working
        set isolate? true                                             ; and in isolation
        ifelse count workers with [on-leave? and not isolate?] > 0 [  ; If there are any staff members at home who aren't working and not in isolation
          ask patches in-radius 5 with [staff-spot = 1] [             ; First the staff member moving to isolation indicated which till needs staff
            set needs-staff? 1]
          let place house
          move-to one-of patches with [residential = place]           ; then they move home to isolate
          ask one-of workers with [on-leave? and not isolate?] [      ; one of the afformentioned available substitute staff
            move-to one-of patches with [needs-staff? = 1]            ; then moves to the vacant till
            set on-leave? false                                       ; updating their working status
            ask patches in-radius 5 with [needs-staff? = 1] [
              set needs-staff? 0]]                                    ; and marking the till station as no longer vacant
        ][
        ask patches in-radius 5 with [till = 1] [                     ; if no staff are available
          set till-free? false                                        ; the till station is marker as unavailable for customer processing
          set free-tills free-tills - 1]                              ; and the number of free tills is reduced
        ask patches in-radius 5 with [staff-spot = 1] [
            set needs-staff? 1]                                       ; the till is then marked as vacant
        let place house
        move-to one-of patches with [residential = place]]            ; and the staff member moved home to isolate
    ]]
      if incubation-period = 11 [                                     ; at 11 days post exposure
        get-recovered                                                 ; the infected staff recovers from COVID-19, updating their disease state
        set incubation-period 0                                       ; their incubation period is reset
        set isolate? false                                            ; and they indicate that they are no longer in isolation
        if count patches with [needs-staff? = 1] > 0 [                ; if there are any vacant tills
          move-to one-of patches with [needs-staff? = 1]              ; the staff member moves to that till
          set on-leave? false                                         ; indicating their return to work
          ask patches in-radius 5 with [needs-staff? = 1] [
              set needs-staff? 0]                                     ; and marking the vacant till as no longer vacant.
          ask patches in-radius 5 with [till = 1] [
            set till-free? true                                       ; the till is then indicated as available for processing customers
            set free-tills free-tills + 1]                            ; increasing the number of tills available
        ]
      ]
]
end

to get-tested                                                                        ; Procedure for testing staff for covid 19
  if infectious? or exposed? [                                                       ; If a customer is infected
    let chance-detect 0                                                              ; Their chance of detecting the infection varies over the viral incubation period
    ifelse test-sensitivity = "Less Sensitive" [                                     ; with test sensitivities varying between tests
      if incubation-period = 3 [set chance-detect 1]
      if incubation-period = 4 [set chance-detect 25]
      if incubation-period = 5 [set chance-detect 61]
      if incubation-period = 6 [set chance-detect 80]
      if incubation-period = 7 [set chance-detect 87]
      if incubation-period = 8 [set chance-detect 85]
      if incubation-period = 9 [set chance-detect 77]
      if incubation-period = 10 [set chance-detect 65]
      if incubation-period = 11 [set chance-detect 55]
      if incubation-period = 12 [set chance-detect 40]
      if incubation-period = 13 [set chance-detect 30]
      if incubation-period = 14 [set chance-detect 22]][
      ifelse test-sensitivity = "More Sensitive" [          ;  RT-PCR
        if incubation-period = 3 [set chance-detect 27]
        if incubation-period = 4 [set chance-detect 45]
        if incubation-period = 5 [set chance-detect 75]
        if incubation-period = 6 [set chance-detect 97]
        if incubation-period = 7 [set chance-detect 100]
        if incubation-period = 8 [set chance-detect 98]
        if incubation-period = 9 [set chance-detect 90]
        if incubation-period = 10 [set chance-detect 77]
        if incubation-period = 11 [set chance-detect 68]
        if incubation-period = 12 [set chance-detect 58]
        if incubation-period = 13 [set chance-detect 47]
        if incubation-period = 14 [set chance-detect 40]][  ;  Base/Average Sensitivity
        if incubation-period = 3 [set chance-detect 10]
        if incubation-period = 4 [set chance-detect 35]
        if incubation-period = 5 [set chance-detect 67]
        if incubation-period = 6 [set chance-detect 85]
        if incubation-period = 7 [set chance-detect 92]
        if incubation-period = 8 [set chance-detect 90]
        if incubation-period = 9 [set chance-detect 82]
        if incubation-period = 10 [set chance-detect 70]
        if incubation-period = 11 [set chance-detect 60]
        if incubation-period = 12 [set chance-detect 50]
        if incubation-period = 13 [set chance-detect 40]
        if incubation-period = 14 [set chance-detect 30]]]
    if random-float 100 < chance-detect [                              ; if the case is detected
        set on-leave? true                                             ; the staff member indicates a move home
        set isolate? true                                              ; in order to isolate
        ifelse count workers with [on-leave? and not isolate?] > 0 [   ; procedures to replace their vacancy at work as the same as those seen in the 'progress-disease' procedure
          ask patches in-radius 5 with [staff-spot = 1] [
            set needs-staff? 1]
          let place house
          move-to one-of patches with [residential = place]
          ask one-of workers with [on-leave? and not isolate?] [
            move-to one-of patches with [needs-staff? = 1]
            set on-leave? false
            ask patches in-radius 5 with [needs-staff? = 1] [
              set needs-staff? 0]]
        ][
        ask patches in-radius 5 with [till = 1] [
          set till-free? false
          set free-tills free-tills - 1]
        ask patches in-radius 5 with [staff-spot = 1] [
            set needs-staff? 1]
        let place house
        move-to one-of patches with [residential = place]]]
  ]

end

to get-susceptible ;;                                   ; procedure to indicate disease state as susceptible
  set susceptible? true                                 ; indicate associated disease state
  set exposed? false
  set infectious? false
  set recovered? false
  set immunity 0                                        ; no immunity for susceptible individuals
  set color green                                       ; represented as green
  if breed = people [
    set susceptible-customers susceptible-customers + 1   ; increase counts indicating the number of susceptible and receptive individuals
    set infectible-customers infectible-customers + 1]
end

to get-infectious                                       ; procedure to indicate disease state as infectious
  set susceptible? false                                ; indicate associated disease state
  set exposed? false
  set infectious? true
  set recovered? false
  set immunity 100                                      ; cannot be infected if already infected
  ifelse random 101 <= proportion-asymptomatic [set asymptomatic? TRUE][set asymptomatic? FALSE] ; assign related proportional chance of an asymptomatic case
  set color red                                         ; represented as red
  if breed = people [
    set infected-customers infected-customers + 1 ]     ; increase count of infectious customer arrivals
end

to get-recovered                                        ; procedure to indicate disease state as recovered for staff recovery
  set susceptible? false                                ; indicate associated disease state
  set exposed? false
  set infectious? false
  set recovered? true
  set immunity 99                                       ; Indicate aquired immunity
  set incubation-period 0                               ; reset incubation period
  set color grey                                        ; represented as grey
end

to get-vax                                              ; procedure to indicate partial vaccination
  set susceptible? false                                ; indicate associated disease state
  set exposed? false
  set infectious? false
  set recovered? false
  set v1? true
  set v2? false
  set immunity v1-efficacy                              ; Indicate aquired immunity
  set color cyan                                        ; represented as light blue
  if breed = people [
    set infectible-customers infectible-customers + 1 ] ; increase counts indicating the number of receptive individuals
end

to get-fully-vax                                        ; procedure to indicate full vaccination
  set susceptible? false                                ; indicate associated disease state
  set exposed? false
  set infectious? false
  set recovered? false
  set v1? false
  set v2? true
  set immunity v2-efficacy                               ; Indicate aquired immunity
  set color blue                                         ; represented as dark blue
  if breed = people [
    set infectible-customers infectible-customers + 1]   ; increase counts indicating the number of receptive individuals
end

to get-sick                                             ; procedure to infection pre-infectiousness
  set susceptible? false                                ; indicate associated disease state
  set exposed? true                                     ; update disease states
  set immunity 100                                      ; set immunity to prevent double counting infections
  set color 44                                          ; represented as yellow
  set total-shop-infections total-shop-infections + 1   ; Update transmission counts
  ifelse breed = people [
  ifelse shop-queued? or join-queue? [set shopq-infections shopq-infections + 1] [   ; Indicating where the transmission took place
  ifelse till-queued? [set tillq-infections tillq-infections + 1] [
  ifelse shopping? and serviced? = false [set shop-infections shop-infections + 1] [
  ifelse serviced? [set till-infections till-infections + 1] [set shopq-infections shopq-infections + 1] ]]]] [set staff-infections staff-infections + 1]

end
@#$#@#$#@
GRAPHICS-WINDOW
628
114
2130
1332
-1
-1
3.35
1
10
1
1
1
0
0
0
1
0
445
0
360
1
1
1
ticks
30.0

BUTTON
1266
32
1370
80
SETUP
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1470
30
1572
78
GO
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1894
56
1952
105
Day
day
0
1
12

TEXTBOX
1900
24
1948
60
Day
15
0.0
1

TEXTBOX
1984
22
2036
58
Hour
15
0.0
1

TEXTBOX
2062
22
2124
58
Minute
15
0.0
1

MONITOR
1976
56
2034
105
Hour
hour
0
1
12

MONITOR
2058
56
2116
105
Minute
minute
0
1
12

MONITOR
2504
278
2574
327
Shop Infections
total-shop-infections
0
1
12

SLIDER
362
328
568
361
prevalence
prevalence
0
20
5.0
0.5
1
%
HORIZONTAL

SLIDER
364
558
568
591
v1-coverage
v1-coverage
0
100
49.0
1
1
%
HORIZONTAL

SLIDER
364
636
568
669
v2-coverage
v2-coverage
0
100
39.8
1
1
%
HORIZONTAL

MONITOR
2480
860
2596
913
NIL
total-shop-time / shopped
1
1
13

MONITOR
2196
278
2266
323
till infections
shopq-infections
0
1
11

MONITOR
2196
326
2266
371
NIL
shop-infections
0
1
11

MONITOR
2196
374
2266
419
NIL
tillq-infections
0
1
11

MONITOR
2196
422
2266
467
NIL
till-infections
0
1
11

TEXTBOX
2590
280
2690
320
Total Transmissions
14
0.0
1

TEXTBOX
2280
280
2406
322
Shop Queue Transmissions
14
0.0
1

TEXTBOX
2280
336
2458
378
Shop Transmissions
14
0.0
1

TEXTBOX
2280
374
2398
414
Till Queue Transmissions
14
0.0
1

TEXTBOX
2280
438
2458
474
Till Transmissions
14
0.0
1

TEXTBOX
2255
815
2330
851
Customers per Day
15
0.0
1

TEXTBOX
2160
865
2235
921
All Customers
15
0.0
1

TEXTBOX
2160
965
2210
985
Small
15
0.0
1

TEXTBOX
2160
1015
2228
1033
Medium
15
0.0
1

TEXTBOX
2160
1065
2206
1101
Large
15
0.0
1

TEXTBOX
2375
815
2465
850
Shop Queue Time
15
0.0
1

TEXTBOX
2495
815
2575
851
Shopping Time
15
0.0
1

TEXTBOX
2615
815
2715
851
Till Queue Time
15
0.0
1

MONITOR
2235
858
2341
911
NIL
shopped / day
0
1
13

MONITOR
2235
950
2340
1003
NIL
shopped1 / day
0
1
13

MONITOR
2235
1005
2340
1058
NIL
shopped2 / day
0
1
13

MONITOR
2235
1060
2340
1113
NIL
shopped3 / day
0
1
13

MONITOR
2365
860
2470
913
NIL
total-shopq-time / shopped
0
1
13

MONITOR
2605
860
2720
913
NIL
total-tillq-time / shopped
0
1
13

MONITOR
2365
950
2471
1003
NIL
shopq-time1 / shopped1
0
1
13

MONITOR
2480
950
2596
1003
NIL
shop-time1 / shopped1
0
1
13

MONITOR
2605
950
2720
1003
NIL
tillq-time1 / shopped1
0
1
13

MONITOR
2365
1005
2470
1058
NIL
shopq-time2 / shopped2
0
1
13

MONITOR
2480
1005
2595
1058
NIL
shop-time2 / shopped2
0
1
13

MONITOR
2605
1005
2720
1058
NIL
tillq-time2 / shopped2
0
1
13

MONITOR
2365
1060
2470
1113
NIL
shopq-time3 / shopped3
0
1
13

MONITOR
2480
1060
2595
1113
NIL
shop-time3 / shopped3
0
1
13

MONITOR
2605
1060
2720
1113
NIL
tillq-time3 / shopped3
0
1
13

MONITOR
2504
366
2574
423
NIL
environmental-infections
17
1
14

MONITOR
2196
524
2270
581
NIL
total-shop-infections / infected-customers
2
1
14

MONITOR
2196
586
2270
647
NIL
total-shop-infections / susceptible-customers
2
1
15

MONITOR
2196
652
2272
709
RtVax
total-shop-infections / infectible-customers
2
1
14

SWITCH
2530
170
2706
203
view-contamination?
view-contamination?
0
1
-1000

TEXTBOX
74
982
434
1026
Transmission Control Measures
17
0.0
1

TEXTBOX
92
1042
276
1068
Vaccine Scenarios
16
0.0
1

CHOOSER
364
1026
592
1071
vaccine-scenario
vaccine-scenario
"No Vaccines" "Standard Vaccine Schedule" "Staff Vaccine Mandate" "Full Vaccine Mandate"
1

TEXTBOX
94
1100
286
1126
Social Distancing
16
0.0
1

CHOOSER
364
1086
594
1131
social-distancing?
social-distancing?
false true
0

TEXTBOX
94
1158
258
1194
Capacity Limit
16
0.0
1

CHOOSER
364
1146
594
1191
capacity-limit
capacity-limit
"None" "50%" "75%"
0

TEXTBOX
96
1216
322
1242
Staff COVID Testing
16
0.0
1

CHOOSER
364
1206
594
1251
staff-testing
staff-testing
"None" "Daily" "Weekly"
0

TEXTBOX
98
1278
230
1309
Sanitization
16
0.0
1

CHOOSER
364
1266
592
1311
sanitization
sanitization
"None" "Entrance" "Entrance and Tills"
0

CHOOSER
366
908
570
953
ss-distribution
ss-distribution
"Base Level" "More Contacts" "Fewer Contacts"
0

TEXTBOX
584
20
850
102
Adjust simulation speed using the slider above.
18
0.0
1

TEXTBOX
205
55
400
75
______________________________________________
12
0.0
1

TEXTBOX
2350
48
2605
78
Simulation Monitoring
25
0.0
1

TEXTBOX
204
40
404
71
Simulation Setup
26
0.0
1

TEXTBOX
71
94
326
119
Adjust Variable Model Parameters
17
0.0
1

TEXTBOX
2350
70
2595
88
____________________________________________________
11
0.0
1

CHOOSER
362
190
566
235
till-service
till-service
"Base Level" "Slower" "Faster"
0

SWITCH
360
136
566
169
use-base-levels?
use-base-levels?
0
1
-1000

CHOOSER
362
240
566
285
shop-size-distribution
shop-size-distribution
"Base Level" "Fewer Small Shops" "More Small Shops"
0

SLIDER
362
290
568
323
step-size
step-size
20
50
35.0
1
1
NIL
HORIZONTAL

SLIDER
362
366
568
399
direct-trans
direct-trans
2
10
5.0
0.2
1
%
HORIZONTAL

SLIDER
362
412
568
445
contaminant-dissipation
contaminant-dissipation
0.1
5
1.5
0.1
1
%
HORIZONTAL

SLIDER
362
460
568
493
proportion-asymptomatic
proportion-asymptomatic
70
80
75.0
1
1
%
HORIZONTAL

SLIDER
362
508
568
541
asym-relative-inf
asym-relative-inf
77.5
82.5
80.0
0.1
1
%
HORIZONTAL

SLIDER
364
596
568
629
v1-efficacy
v1-efficacy
30
67
52.0
1
1
%
HORIZONTAL

SLIDER
366
676
568
709
v2-efficacy
v2-efficacy
90
98
95.0
1
1
%
HORIZONTAL

TEXTBOX
72
140
322
171
Use base parameter levels?
15
0.0
1

TEXTBOX
90
205
320
226
Till Service Speed
16
0.0
1

TEXTBOX
67
170
551
200
______________________________________________________________________________
11
0.0
1

TEXTBOX
92
250
342
281
Distribution of Shop-Sizes
16
0.0
1

TEXTBOX
92
297
298
323
Movement Speed
16
0.0
1

TEXTBOX
92
334
328
354
COVID-19 Prevalence
16
0.0
1

TEXTBOX
92
368
350
388
Direct Transmission Chance
16
0.0
1

TEXTBOX
92
404
368
455
Environmental Contamination Dissipation Rate
16
0.0
1

TEXTBOX
90
460
356
511
Proportion of Asymptomatic Cases
16
0.0
1

TEXTBOX
92
500
364
551
Relative Infectiousness of Asymptomatic Cases
16
0.0
1

TEXTBOX
94
564
358
590
Partial Vaccination Coverage
16
0.0
1

TEXTBOX
94
602
360
628
Partial Vaccination Efficacy
16
0.0
1

TEXTBOX
94
636
350
662
Full Vaccination Coverage
16
0.0
1

TEXTBOX
94
674
394
710
Full Vaccination Efficacy
16
0.0
1

TEXTBOX
72
722
570
758
__________________________________________________________________________________
11
0.0
1

TEXTBOX
72
750
540
801
Transmission Control Measure Parameters
17
0.0
1

TEXTBOX
96
800
332
856
Relative Contaminant Level post Sanitizer 
16
0.0
1

TEXTBOX
96
860
310
901
COVID-19 Test Sensitivity
16
0.0
1

TEXTBOX
96
920
330
956
Super-Spreader Proportions
16
0.0
1

CHOOSER
366
854
570
899
test-sensitivity
test-sensitivity
"Base Level" "Less Sensitive" "More Sensitive"
0

SLIDER
366
808
570
841
sanitizer-disinfection
sanitizer-disinfection
60
90
70.0
1
1
%
HORIZONTAL

TEXTBOX
2176
118
2476
149
Transmission Dynamics
17
0.0
1

TEXTBOX
2178
168
2478
209
Make Environmental Contamination Visible?
16
0.0
1

TEXTBOX
2196
230
2426
266
Transmission Counts
16
0.0
1

TEXTBOX
2590
380
2695
415
Environmental Transmissions
14
0.0
1

MONITOR
2504
322
2574
371
NIL
total-shop-infections - environmental-infections
17
1
12

TEXTBOX
2590
325
2695
360
Direct Transmissions
14
0.0
1

TEXTBOX
2178
210
2722
246
_________________________________________________________________________________________
11
0.0
1

TEXTBOX
2200
485
2500
521
Transmission Ratios
16
0.0
1

TEXTBOX
2290
542
2646
568
Total Transmissions:Infectious Arrivals
15
0.0
1

TEXTBOX
2290
606
2668
632
Total Transmissions:Susceptible Arrivals
15
0.0
1

TEXTBOX
2290
666
2686
702
Total Transmissions:Receptive Arrivals
15
0.0
1

PLOT
2742
242
3306
716
Transmission Counts
Time (min)
Transmissions
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total " 1.0 0 -16777216 true "" "plot total-shop-infections"
"Environmental" 1.0 0 -10899396 true "" "plot environmental-infections"
"Direct" 1.0 0 -2139308 true "" "plot (total-shop-infections - environmental-infections)"
"Shop Queue" 1.0 0 -11221820 true "" "plot shopq-infections"
"Shop" 1.0 0 -1184463 true "" "plot shop-infections"
"Till Queue" 1.0 0 -13345367 true "" "plot tillq-infections"
"Till" 1.0 0 -8630108 true "" "plot till-infections"

MONITOR
2504
422
2574
479
NIL
staff-infections
17
1
14

TEXTBOX
2590
430
2675
461
Staff Transmissions
14
0.0
1

TEXTBOX
2185
750
2335
771
Customer Dynamics
17
0.0
1

TEXTBOX
2185
725
2750
743
___________________________________________________________________________________________
11
0.0
1

TEXTBOX
2390
775
2640
795
Observed Simulation Averages
16
0.0
1

TEXTBOX
2160
920
2245
938
By Shop-Size
15
0.0
1

TEXTBOX
2160
930
2245
948
______________
11
0.0
1

TEXTBOX
2385
785
2615
811
______________________________________
11
0.0
1

TEXTBOX
2230
1140
2510
1165
Observed Maximum Queuing Times
16
0.0
1

TEXTBOX
2225
1150
2495
1168
____________________________________________
11
0.0
1

TEXTBOX
2245
1180
2330
1200
Shop Queue
15
0.0
1

TEXTBOX
2385
1180
2455
1200
Till Queue
15
0.0
1

MONITOR
2235
1205
2340
1262
NIL
max-shopq-time
17
1
14

MONITOR
2365
1205
2472
1262
NIL
max-tillq-time
17
1
14

TEXTBOX
2585
1140
2705
1158
Customers Lost
16
0.0
1

TEXTBOX
2580
1150
2730
1168
____________________
11
0.0
1

MONITOR
2585
1205
2702
1262
NIL
lost-customers
17
1
14

PLOT
2740
800
3305
1335
Customers at each location
Time (min)
No. of Customers
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Total" 1.0 0 -16777216 true "" "plot count people"
"Shop Queue" 1.0 0 -8990512 true "" "plot count people with [shop-queued?]"
"Shopping" 1.0 0 -1184463 true "" "plot count people with [shopping? and not serviced? and not till-queued?]"
"Till Queue" 1.0 0 -13345367 true "" "plot count people with [till-queued?]"
"Till Stations" 1.0 0 -8630108 true "" "plot count people with [serviced?]"

TEXTBOX
2905
760
3200
796
No. of Customers at each Location
15
0.0
1

TEXTBOX
2925
205
3075
223
Transmission Counts
15
0.0
1

TEXTBOX
45
90
60
116
1
22
6.0
1

TEXTBOX
50
745
65
771
2
22
6.0
1

TEXTBOX
50
980
65
1006
3
22
6.0
1

TEXTBOX
1225
40
1240
66
4
22
6.0
1

TEXTBOX
1430
40
1450
66
5
22
6.0
1

BUTTON
965
30
1108
80
VIEW ENVIRONMENT
draw-map
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
# WHAT IS IT?

This model simulates the transmission and customer dynamics in a supermarket environment, facilitating the spread of the COVID-19 virus and the implementation of available control measures aimed at limiting transmission, while factoring for the effects of Super-Spreaders and their related compliance with the measures implemented.   

# HOW IT WORKS

After the selection of defining parameters the model is initialised at the opening time of the represented supermarket, with COVID-19 transmission control measures implemented as defined by the user and staff awaiting the arrival of the first customer for the day.

Upon arrival customers move around the shop environment, passing through the steps of movement through the queue to the shop entrance, between collection points for items in the supermarket, through the queue for the tills, and checking out at one of the three till stations before leaving the shop.

Both customers and workers can fall into one of the following states: 

- healthy but susceptible to infection with no immunity (green)  
- exposed to COVID-19 but not yet infectious (yellow)  
- exposed to COVID-19 and infectious (red)  
- having received partial vaccination (carrying a degree of vaccine-induced immunity to COVID-19) (light blue)  
- having received full vaccination (carrying a larger degree of vaccine-induced immunity to COVID-19) (dark blue)

and workers can fall into the additional disease state of:
- recovered from having COVID-19 (carrying aquired immunity) (grey)   
 
The relative effectiveness of the COVID-19 transmission control measures implemented is evaluated through the simulation of their use in the supermarket over a desired period of time, making use of the model's Simulation Monitoring environment to inspect the associated measures of Transmission Dynamics and Customer Dynamics respectively.  

The model contains a wide selection of input parameters relating to the underlying mechanisms governing customer and transmission dynamics in the model, as well as a selection of input parameters relating to the implementation of transmission control measures. 

The base parameter levels are preset and are based on selected rates and proportions defined in academic literature, or sourced through surveys at local supermarkets in South Africa.

You can adjust these variables by either selecting options from a drop down menu or by sliding the slider to the desired experimental percentage for each variable.   

These factors are described in more detail below to get a better understanding of the model dynamics.  

## Adjustable input parameters

The following measures are the input parameters that govern the operation of the base model, affecting the way operations take place in the environment and defining the mechanisms driving COVID-19 transmission.  As the real-world levels for these measures varies over time with improved research or the arrival of new variants, the parameter values may be adjusted to better suit and represent the real-world scenarios it aims to replicate.  This can also be done preemtively, to answer questions relating to the performance of different measures in the system under 'what if?' scenarios such as the arrival of a more transmissible strain.  The input parameter variables are described in more detail below, beginning by looking at the Customer Dynamics related parameters before decribeing parameters relating to COVID-19 Transmission Dynamics 

### Customer Dynamics Parameters

The following parameters define the performance of underlying customer dynamics, through changes in movement and processing. 

* 'TILL SERVICE SPEED':  The till service speed chooser acts as measure for th relative customer processing times, such that a 'faster' value for the till service speed parameter is associated with shorter customer service times to checkout purchases.  (The chooser has 3 levels: base level, slower, and faster; preset at base level)

* 'DISTRIBUTION OF SHOP SIZES':  The distribution of shop-sizes chooser provides an indication of the relative proportions of customers that have small, medium, and large shop-sizes respectively.  The customer shop-size is a measure of the extent of the shop they intend to do, with a large shop size corresponding to buying more items, and hence visiting more points in the shop.  (The chooser has 3 options: base level, fewer small shops, more small shops; preset at base level)

* 'MOVEMENT SPEED':  The movement speed slider dictates the speed a customer has as they move around the shop environment.  The slider provides an indication of the relative distance traveled between each time step, defining the step-size a customer takes.  This parameter can be used in order to lengthen or shorten the amount of time a customer spends in the shop.  (The slider has a range from 20 to 50; preset at 35)

### Transmission Dynamics Parameters

The following parameters define the transmission dynamics of COVID-19 in the supermarket, through changes in relative transmissibility of the virus as well as variation in immunity levels.

* 'COVID-19 PREVELANCE':  The COVID-19 prevalence slider dictates the prevalence in the calling population in the supermarket environment. The proportion of customers that arrive at the shop environment as an Infectious case of COVID-19 is equivalent to the prevalence level selected. (The slider is preset at 5%)

* 'DIRECT TRANSMISSION CHANCE':  The direct transmission chance slider determines the transmissibility of the COVID-19 virus by defining the chance of transmission between infectious and susceptible individuals provided sufficient contact is made. If a more transmissible variant was to be discovered, the direct transmission chance slider could be increased to reflect this change.  (The Slider is preset slider at 5%)

* 'ENVIRONMENTAL CONTAMINATION DISSIPATION RATE':  The environmental contamination dissipation rate slider determines the rate at which environmental contamination of COVID-19 aerosols and fomites dissipated or becomes inactive. The rate defines the decay percentage for the exponential decay of the contamination present.  (The slider is preset at 1.5%) 

* 'PROPORTION OF ASYMPTOMATIC CASES':  This parameter dictates the proportion of arrivals and transmissions that are infectious but asymptomatic.  Additionally, Infected staff that are Asymptomatic do not take leave at the timepoint of symptom onset.  (The slider is preset at 75%)

* 'RELATIVE INFECTIOUSNESS OF ASYMPTOMATIC CASES':  This parameter indicates the relative infectiousness of Asymptomatic cases compared to a Symptomatic case.  This parameter acts as a multiplier to reduce the chance of direct transmission as well as the infectiousness of Environmental Contamination dispersed.  (preset slider at 80%)

* 'PARTIAL VACCINATION COVERAGE':  This parameter represents the percentage of individuals having received at least a partial vaccination.  The parameter dictates the chance of having received at least a partial vaccination, and thus includes those who are fully vaccinated, as defined by the South African Vaccination Monitoring Dashboard.  (The slider is preset at 49%)

* 'PARTIAL VACCINATION EFFICACY':  This parameter represents the efficacy of having partial vaccination. The parameter dictates the chance of infection for partially vaccinated individuals given that conditions for transmission take place.  (The slider is preset at 52%)

* 'FULL VACCINATION COVERAGE':  This parameter represents the percentage of individuals having received a full vaccination.  (The slider is preset at 39.8%)

* 'FULL VACCINATION EFFICACY': This parameter represents the efficacy of having full vaccination. The parameter dictates the chance of infection for fully vaccinated individuals given that conditions for transmission take place.  (The slider is preset at 95%)

## Transmision Control Measure Parameters

The following parameters relate to the implementation of one or more of the control measures that may be implemented.  These parameters have no effect in the Base Model performance with no control measures in use.

* 'RELATIVE CONTAINMENT LEVEL POST SANITIZER':  This parameter describes the relative amount of environmental contaminant distributed by an Infectious Customer/Staff Member at each location visited.  Amount selected is given as a percentage.  (The slider is preset at 70%)

* 'COVID-19 TEST SENSITIVITY':  This parameter defines the diagnostic sensitivity of COVID-19 tests conducted on Staff members for Staff COVID-19 Testing.  Sensitivity is based on a variety of Rapid Antigen tests and the RT-PCR test, with sensitivity varying according to the viral incubation period. (The chooser has 3 options: Base Level, Less Sensitive, and More Sensitive; preset at Base Level)

* 'SUPER-SPREADER PROPORTIONS':  This parameter dictates the relative proportions of  individuals classified into five degrees of intensity of Super-Spreader behaviour. Individuals with a higher degree of Super-Spreader intensity are likely to have more daily contacts with a higher resulting chance of infectiousness and less likely to comply with intervention protocols.  Defined by 5 levels of super-spreader intensity, with varied proportions of the population assigned to each.  (The chooser has 3 options: Base Level, More Contacts, and Fewer Contacts; preset at Base Level)

## Transmission Control Measures

The control measures described in this section are implemented in the shop environment in an attempt to reduce the number of COVID-19 transmissions that take place.  Five of the more commonly implemented control measures are considered for implementation at a variety of implementation-levels in this model.

These transmission control measures may be implemented independently in isolation to one another, or as a combination of any or all of the control measures.  The selection of control measures should be conducted before model setup and the initialisation of the simulation.  Thus the use-level of each control measure may not change throughout the simulation period.

### 'VACCINE SCENARIOS' 

Each person in the simulation environment has an assigned immunity level between 0 and 100, representative of their independent chance of becoming infected provided the conditions are met for transmission to take place.  As this is a proportional percentage, the vaccine efficacy levels form a sufficient measure of individual immunity. 

The chooser for this control measure defines 4 distinct use-levels as follows:

* No Vaccines:  At initialisation, all staff are Susceptible and Customer arrivals will either be Susceptible or Infectious proportional to the set prevalence level.

* Standard Vaccine Schedule:  At initialisation, all staff are Susceptible and Customer arrivals will be Fully Vaccinated proportional the Full Vaccination coverage level, Partially Vaccinated proportional the Partial Vaccination coverage level less the Full Vaccination coverage level (as per coverage definition), Susceptible, or Infectious proportional to the set prevalence level.

* Staff Vaccine Mandate:  At initialisation, all staff are Fully Vaccinated and Customer arrivals will be Fully Vaccinated proportional the Full Vaccination coverage level, Partially Vaccinated proportional the Partial Vaccination coverage level less the Full Vaccination coverage level (as per coverage definition), Susceptible, or Infectious proportional to the set prevalence level. 

* Full Vaccine Mandate:  At initialisation, all staff are Fully Vaccinated and Customer arrivals will be Fully Vaccinated, or Infectious proportional to the set prevalence level.

The preset Base Level for this chooser is the Standard Vaccine Schedule.

### 'SOCIAL DISTANCING'

Each customer in the simulation environment has an assigned personal-space, representative of the independent amount of space they would leave between themselves and other customers.  This amount of space is a fixed number when no Social Distancing is implemented, this amount of space is considered a standard personal-space level that all individuals are likely to keep in the shop environment in a standard shopping situation.  When Social Distancing is implemented, this personal-space distance is doubled.  However, individuals that exhibit high levels of super-spreader behaviour are likely to exhibit non-compliance to the required social distance to varying degrees.  Individuals with the highest super-spreader behaviour level exhibit between 0 and 100% compliance with the extra Social Distancing on a uniform distribution, and individuals with the second highest super-spreader behaviour level exhibit between 30 and 100% compliance with the extra Social Distancing on a uniform distribution. 

The chooser for this control measure has two options indicating whether social distancing in implemented or not: True, and False.

The preset Base Level for this chooser is False.

### 'CAPACITY LIMIT' 

The implementation of the Capacity Limiting control measure in the simulation model involves setting a level for the global capacity-limit parameter.  When a customer arrives at the Shop and joins the Shop Queue, the customer at the front of the queue will only progress to the procedure of entering the shop if the number of customers in the shop environment is less than the set capacity limit.  If the shop has reached limited capacity, the customer will wait until a customer leaves the shop and some capacity becomes available. 

The chooser for this control measure defines 3 distinct use-levels as follows:

* None:  No Limit on Capacity
* 75%:  Limited the maximum number of customers in the shop to 75% of the mean maximum observed capacity under the Base Model.
* 50%:  Limited the maximum number of customers in the shop to 50% of the mean maximum observed capacity under the Base Model.

The preset Base Level for this chooser is None.

### 'STAFF COVID TESTING' 

The implementation of the Staff COVID-19 Testing control measure in the model involves testing all staff for COVID-19 at the set Weekly or Daily intervals.  Exposed or Infectious staff members report a positive test result at the test sensitivity levels corresponding to their incubation-period and assigned relative test-sensitivity.  Upon receiving a positive test result, the staff member will be required to isolate until their recovery from COVID-19.

* None:  No Staff COVID-19 Testing
* Weekly:  Implements a COVID-19 test once per week in the middle of the week, this allows time for antigens to develop if infected early on to increase chances of a positive result in the first test and allows for time effects of isolation to be shown by allowing observation of the days following the second test.
* Daily:  Implements a COVID-19 test each day of the simulation period.

The preset Base Level for this chooser is None.

### 'SANITIZATION' 

The implementation of the Sanitization control measure in the simulation model involves the use of sanitizer for personal hygiene, by sanitizing hands at the shop Entrance, and surface sanitization, by sanitizing surfaces at the Tills.  With sanitizer use at the shop Entrance, Infectious Customers entering the shop have a reduced contaminant level that is left behind at each area they come into contact with.  This reduction describes the reduction in the spread of fomites due to the inactivation of particles that would have been on the customer's hands.  However, this has no effect on the spread of aerosols.  The reduction in the level of environmental contaminant spread is shown as a proportion of the full contaminant level and indicated by the sanitizer-disinfection parameter.  The use of sanitizer as a surface disinfectant at the Till Stations is implemented by clearing surface fomites between each customer processed.

The implementation of Sanitization also results in added processing times with an extra minute (smallest available time step) added to entering the shop, as well as an added minute to sanitize Till Station surfaces between customers. As the added time to process shop entrance is longer than would be seen in real-world implementation, it may be analogous to other time consuming entry processes such as filling out contact tracing details. Thus we will define the implementation of sanitization in conjunction with the implementation of such measures.

The chooser for this control measure defines 3 distinct use-levels as follows:

* None:  No Sanitization
* Entrance:  Sanitization which describes the use of hand sanitization for customers entering the shop.
* Entrance and Tills:  Sanitization which describes the use of hand sanitization for customers entering the shop as above, as well as the use of sanitizer as a surface disinfectant at the Till Stations.

The preset Base Level for this chooser is None.

## Simulation Monitoring

### Simulation Time

The Day, Hour and Minute monitors above the shop environment view, display the time lapsed as the simulation runs and may indicate when it is paused.  

### Environmental Contamination Visibility

This switch can be turned on to display the infected surfaces and the duration of their infectiousness during the simulation.  

### Transmission Dynamics Tab

The Transmission Dynamics Tab is found in the top-right section of the application window,just to the right of the Shop Environment View.  This simulation monitoring tab is the section of the environment containing all the Transmission Dynamics related value monitors.  Looking at the image of the Transmission Dynamics Tab, the first item in the tab is the switch that enables viewing of the extent of environmental contamination in the environment.  Below that is a list of Transmission Counts in two columns.  The left-hand columnshows  the  transmission  counts  in  each  section  of  the  shop  environment  and  the  right-handcolumn shows the transmission counts of total, direct, environmental, and staff transmissionsrespectively.  This is accompanied by the plot to the right of these monitors showing the changein all of these transmission counts over the entire simulated period.

### Customer Dynamics Tab

This simulation monitoring tab is the section ofthe environment containing all the Customer Dynamics related value monitors. The first section is a collectionof monitors indicating mean values for the number of customers processed per day, along with the mean times for customer shop queuing, shopping, and till queuing respectively.  The first row  of  monitors  shows  the  values  for  these  means  for  all  customers, followed  by  three  more rows indicating these mean values for customers grouped according to the size of the shop they conducted in the environment.  This is accompanied by the plot to the right of these monitorsshowing the change in the number of customers in each of the shop environment sections, as well as the total number of customers present, for each time point over the entire simulated period.  Below these are three Customer Dynamics monitors for values of interest, namely those of themaximum queuing times for the shop and till queues, followed by the total number of customers lost due to balking on the left and right respectively.  Just as seen for the Transmission Dynamics Tab, all of these monitors and the plot are updated constantly for every minute of the simulation.



# HOW TO USE IT

Each "tick" represents one minute in the time scale of the model.

The use of the model relies on the preselection of input parameters and control measures before the initialisation of the model when clicking 'SETUP'. 

In order to do this, the required steps to initiate the model are indicated by the numbers shown in the environment. Each of these steps is described below:

## Parameter Selection

### 1. Selecting Variable Base Model Parameters

There is one available preset parameter-set of this model that is activated automatically upon initialisation and deactivated by clicking the red toggle on the 'Use base parameter levels?' switch.  This setup procedure initialises the model with values and percentages for the adjustable input variables for the Base Model according to the preset levels described above. 

The user may also decide not to use Base Levels for the parameters as set the switch to indicate NO.  Thereafter, the Base Input parameters described above may be varied by adjusting values with the available sliders and choosers.

### 2. Selecting Transmission Control Measure Parameters

Similarly to step 1, input values for the transmission control measure parameters described above, may be changed and varied using the associated sliders and choosers available.
 
## Control Measure Choice 

### 3. Transmission Control Measure Selection  

The third step involves the choice of transmission control measures and combinations thereof at the desired implementation levels defined above. These control measures will be put in use for the duration of the disired simulation period upon setup of the model.

## Running the Simulation

### 4.  'SETUP' Button

This step initializes all user adjusted Variable Model Parameters and Transmission Control Measures and calibrates the simulation to the specifications described.  This button also clears and resets the Simulation Monitoring monitors and plots from any previous runs.    

### 5.  'GO' Button

This step initiates and runs the simulation to produce new data pertaining to the Customer Dynamics and Transmission Dynamics in the Model.  It also acts as a pause button if you require the simulation to hault, which may also resume the simulation when selected for a third time.  




# THINGS TO NOTICE

Take note of changes in the behaviour of the customers as they move through the environment and interact with one another between scenarios.  Changes in queue congestion or staff vacancies may provide valueable insight into the underlying reasons for major changes in the observed metrics shown in the monitors.  This may also serve to provide insight into any weakpoints or risks in the implementation of real-world control measure applications.

# THINGS TO TRY

Try selecting various combinations of transmission control measures at varied levels of implementation, and allowing the model to run for extended periods of time. Try to observe and take note of considerable changes in the customer and transmission dynamics that result from the implementation of different control measures and combinations thereof.  Try to take note of any unexpected changes resulting from implementing a measure, or any effects of interacts that take place between different measures implemented.

Additionally, try to adjust the other parameter inputs to note any changes in the relative performance of the considered control measures.

# EXTENDING THE MODEL

If the model was extended to define increments in time in intervals smaller than one minute, this would enable more accurate model scalability by being able to define customer inter-arrival times less than 1 min, as well as more accurately specified changes in customer dynamics times than as is limited to 1 min increments now.  Particular attention could be made in allowing the increase in shop-queue processing time resulting from the addition of hand sanitization, to be less than 1 min.  This would improve the accuracy of resulting changes in shop queuing time tremendously.

Additionally, extensions to include further variation in COVID-19 disease parameters, such as disease state transition times, would result in improved disease dynamics accuracy.
  

# NETLOGO FEATURES

This model makes use of intricately designed 'Design' turtles.  The rudamentary turtle designer may not be designed for use as a designer purposed for aesthetic simulation builds, but push the limits of its use enables some striking and engaging visuals. 

The software also features 3-Dimensional viewing capabilities, to enhance the experience of the model viewing process and make the simulation experience more immersive. To access this feature, right-click on the viewing window and select 'Switch to 3D View'. 

# CREDITS AND REFERENCES

The basic direct transmission structure of this model was based off of the Virus Model in the NetLogo Models Library. The structure of direct transfer was bassed on the transfer structure from this model:

Wilensky, U. (1998). NetLogo Virus model. http://ccl.northwestern.edu/netlogo/models/Virus. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

# HOW TO CITE 

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Mountford, T. (2022). (NetLogo COVID-19 Supermarket Control Measure Effectiveness.)  Department of Statistical Science, University of Cape Town, Western Cape, South Africa.  

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

accacia tree
false
0
Polygon -6459832 true false 210 87 227 77 231 80 214 89
Polygon -6459832 true false 146 63 149 73 149 81 155 81 155 71 151 62
Polygon -14835848 true false 183 79 170 78 161 71 167 64 179 62 199 65 211 58 230 61 239 71 258 77 265 87 255 88 237 88 232 82 220 80 211 81 197 86 189 81
Polygon -14835848 true false 103 61 90 60 81 53 87 46 99 44 119 47 131 40 150 43 159 53 178 59 185 69 175 70 157 70 152 64 140 62 131 63 117 68 109 63
Polygon -7500403 true true 148 62 152 70 153 80 154 81 154 71 151 63
Polygon -6459832 true false 151 298 181 298 182 269 176 241 160 215 152 189 160 176 174 164 191 165 217 154 232 141 240 133 263 124 269 114 262 112 257 122 238 127 229 134 219 141 207 153 194 158 182 158 168 157 156 164 163 145 173 133 183 123 190 109 184 109 174 126 161 138 152 154 145 168 143 179 139 188 140 201 131 196 129 181 131 173 126 166 121 156 120 145 124 132 135 119 150 111 156 103 148 104 144 110 132 116 125 119 128 115 128 106 125 103 119 105 123 111 121 118 122 126 116 138 115 151 114 158 107 151 99 140 91 130 89 116 84 99 71 95 59 96 71 102 79 106 83 129 94 146 106 162 115 168 122 176 122 185 126 203 135 212 145 220 151 239 155 258 155 272 153 292
Polygon -7500403 true true 173 297 174 266 169 245 157 221 149 194 151 179 165 165 177 162 158 177 152 190 155 202 160 217 175 240 179 258 181 270 179 296
Polygon -7500403 true true 138 201 132 196 130 185 131 175 119 157 121 136 122 132 133 120 149 112 155 103 152 104 148 109 131 118 127 123 120 131 118 156 121 166 129 178 129 183 131 194
Polygon -7500403 true true 69 95 83 100 91 118 91 128 103 147 115 159 109 158 101 147 91 135 89 124 89 118 85 107 81 102
Polygon -7500403 true true 125 104 129 109 129 115 126 118 128 111 125 108
Polygon -7500403 true true 188 111 181 124 175 129 172 134 164 143 155 165 156 157 162 142 171 132 179 125 182 122
Polygon -7500403 true true 268 114 259 126 244 130 240 133 227 145 216 154 199 161 216 152 230 140 238 131 245 128 257 125
Polygon -10899396 true false 67 104 48 109 28 101 16 89 7 90 9 80 25 77 43 73 59 65 71 49 107 47 131 67 133 81 141 84 152 78 178 59 203 71 216 87 247 85 259 75 270 76 277 88 290 97 304 108 299 120 282 123 266 121 266 115 261 114 257 121 240 120 237 112 235 105 231 102 214 108 211 117 208 119 201 121 192 119 189 114 186 109 178 112 171 113 166 111 159 110 156 106 148 106 143 107 137 110 127 107 124 105 112 107 100 109 91 103 84 100 84 100 72 97 64 97
Polygon -14835848 true false 58 76 59 64 69 50 86 49 94 42 119 47 124 53 122 59 122 55 118 48 96 46 82 54 71 53 68 59 63 64 64 68
Polygon -14835848 true false 8 84 15 78 31 77 49 83 51 87 50 88 46 86 33 81 24 81 16 83
Polygon -14835848 true false 84 91 90 79 104 74 119 74 134 81 143 85 144 91 140 86 128 84 119 78 105 78 92 81
Polygon -14835848 true false 158 79 175 65 188 67 199 70 213 82 221 81 217 86 210 84 200 75 197 71 190 69 172 71
Polygon -14835848 true false 289 96 282 90 266 89 248 95 246 99 247 100 251 98 264 93 273 93 281 95
Polygon -13840069 true false 137 298 132 287 135 280 135 287 139 291 141 287 141 284 146 288 145 298 154 298 154 293 152 289 157 295 158 297 158 286 165 279 160 288 162 292 167 291 167 284 171 292 170 298 179 291 178 287 184 291 180 297 193 297 187 286 196 281 191 286 197 299

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ambulance
false
0
Rectangle -7500403 true true 30 90 210 195
Polygon -7500403 true true 296 190 296 150 259 134 244 104 210 105 210 190
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Circle -16777216 true false 69 174 42
Rectangle -1 true false 288 158 297 173
Rectangle -1184463 true false 289 180 298 172
Rectangle -2674135 true false 29 151 298 158
Line -16777216 false 210 90 210 195
Rectangle -16777216 true false 83 116 128 133
Rectangle -16777216 true false 153 111 176 134
Line -7500403 true 165 105 165 135
Rectangle -7500403 true true 14 186 33 195
Line -13345367 false 45 135 75 120
Line -13345367 false 75 135 45 120
Line -13345367 false 60 112 60 142

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bath shelf
false
0
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 45 181 54 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 0 195 45 180 255 180 300 195
Rectangle -16777216 true false 0 195 300 200
Rectangle -1 true false 36 195 54 200
Rectangle -1 true false 93 195 111 200
Rectangle -1 true false 177 195 195 200
Polygon -6459832 true false 0 240 45 225 255 225 300 240
Polygon -6459832 true false 0 285 45 270 255 270 300 285
Rectangle -16777216 true false 0 285 300 290
Rectangle -16777216 true false 0 240 300 245
Rectangle -1 true false 36 240 54 245
Rectangle -1 true false 93 240 111 245
Rectangle -1 true false 222 240 240 245
Rectangle -1 true false 36 285 54 290
Rectangle -1 true false 93 285 111 290
Rectangle -1 true false 222 285 240 290
Rectangle -16777216 true false 0 196 9 300
Rectangle -16777216 true false 291 196 300 300
Rectangle -16777216 true false 150 196 159 300
Rectangle -1 true false 222 195 240 200
Rectangle -1 true false 177 240 195 245
Rectangle -1 true false 177 285 195 290
Polygon -14835848 true false 26 235 26 223 28 221 32 221 36 223 37 234
Polygon -14835848 true false 40 230 40 218 42 216 46 216 50 218 51 229
Polygon -14835848 true false 47 235 47 223 49 221 53 221 57 223 58 234
Polygon -13345367 false false 25 224 29 226 35 224 29 221
Polygon -13345367 false false 47 224 51 226 57 224 51 221
Polygon -13345367 false false 39 219 43 221 49 219 43 216
Polygon -8630108 true false 36 178 25 182 26 191 45 189 50 180
Polygon -8630108 true false 87 177 76 181 77 190 96 188 101 179
Polygon -8630108 true false 62 177 51 181 52 190 71 188 76 179
Polygon -1 false false 26 184 40 185 46 181 46 190 25 190
Polygon -2064490 true false 76 166 65 170 66 179 85 177 90 168
Polygon -2064490 true false 49 167 38 171 39 180 58 178 63 169
Polygon -1 false false 79 183 93 184 99 180 99 189 78 189
Polygon -1 false false 52 183 66 184 72 180 72 189 51 189
Polygon -2674135 false false 67 171 81 172 87 168 87 177 66 177
Polygon -2674135 false false 38 172 52 173 58 169 58 178 37 178
Polygon -14835848 true false 74 235 74 223 76 221 80 221 84 223 85 234
Polygon -14835848 true false 61 229 61 217 63 215 67 215 71 217 72 228
Polygon -13345367 false false 72 224 76 226 82 224 76 221
Polygon -13345367 false false 61 218 65 220 71 218 65 215
Polygon -1 true false 172 233 180 232 179 224 181 205 168 206 171 224
Circle -14835848 false false 169 211 9
Polygon -1 true false 202 237 210 236 209 228 211 209 198 210 201 228
Polygon -1 true false 188 229 196 228 195 220 197 201 184 202 187 220
Circle -14835848 false false 199 215 9
Circle -14835848 false false 185 206 9
Polygon -1 true false 161 281 169 280 168 272 170 253 157 254 160 272
Polygon -1 true false 186 280 194 279 193 271 195 252 182 253 185 271
Polygon -1 true false 173 275 181 274 180 266 182 247 169 248 172 266
Polygon -955883 false false 158 261 168 260 167 272 161 271
Polygon -955883 false false 183 258 193 257 192 269 186 268
Polygon -955883 false false 170 253 180 252 179 264 173 263
Circle -2064490 true false 160 266 6
Circle -2064490 true false 187 262 6
Circle -2064490 true false 174 257 6
Polygon -1 false false 105 186 106 168 110 165 117 167 120 171 120 187
Polygon -10899396 true false 105 179 118 179 118 187 105 186
Polygon -1 false false 125 182 126 164 130 161 137 163 140 167 140 183
Polygon -1 false false 145 189 146 171 150 168 157 170 160 174 160 190
Polygon -10899396 true false 126 174 139 174 139 182 126 181
Polygon -10899396 true false 146 181 159 181 159 189 146 188
Polygon -16777216 true false 111 166 111 163 107 163 107 161 114 162 114 165
Polygon -16777216 true false 151 167 151 164 147 164 147 162 154 163 154 166
Polygon -16777216 true false 132 161 132 158 128 158 128 156 135 157 135 160
Polygon -1 false false 165 182 166 164 170 161 177 163 180 167 180 183
Polygon -1 false false 197 184 198 166 202 163 209 165 212 169 212 185
Polygon -1 false false 183 190 184 172 188 169 195 171 198 175 198 191
Polygon -2064490 true false 198 176 211 176 211 184 198 183
Polygon -2064490 true false 185 182 198 182 198 190 185 189
Polygon -2064490 true false 166 175 179 175 179 183 166 182
Polygon -16777216 true false 203 162 203 159 199 159 199 157 206 158 206 161
Polygon -16777216 true false 188 169 188 166 184 166 184 164 191 165 191 168
Polygon -16777216 true false 170 160 170 157 166 157 166 155 173 156 173 159
Polygon -11221820 true false 231 177 242 181 241 190 222 188 217 179
Polygon -13345367 false false 239 182 225 183 219 179 219 188 240 188
Polygon -11221820 true false 245 166 256 170 255 179 236 177 231 168
Polygon -11221820 true false 261 179 272 183 271 192 252 190 247 181
Polygon -13345367 false false 269 185 255 186 249 182 249 191 270 191
Polygon -13345367 false false 252 171 238 172 232 168 232 177 253 177
Polygon -16777216 true false 93 231 93 210 103 211 104 231
Circle -6459832 false false 94 218 8
Polygon -16777216 true false 132 237 132 216 142 217 143 237
Polygon -16777216 true false 119 229 119 208 129 209 130 229
Polygon -16777216 true false 106 237 106 216 116 217 117 237
Circle -6459832 false false 133 224 8
Circle -6459832 false false 107 224 8
Circle -6459832 false false 120 215 8
Polygon -2674135 true false 199 270 200 276 206 281 242 282 241 273 238 271
Polygon -2674135 true false 242 270 243 276 249 281 285 282 284 273 281 271
Polygon -2674135 true false 215 256 216 262 222 267 258 268 257 259 254 257
Polygon -1 false false 252 274 252 279 280 279 279 274
Polygon -1 false false 210 275 210 280 238 280 237 275
Polygon -1 false false 226 261 226 266 254 266 253 261
Circle -11221820 true false 246 260 7
Circle -11221820 true false 272 274 7
Circle -11221820 true false 229 274 7
Polygon -7500403 true true 220 209 219 211 218 233 220 233 233 233 232 208
Polygon -2674135 false false 220 213 220 232 230 230 229 211
Polygon -13840069 true false 222 216 221 221 225 220 225 231 229 231 228 214
Polygon -7500403 true true 239 208 238 210 237 232 239 232 252 232 251 207
Polygon -7500403 true true 260 207 259 209 258 231 260 231 273 231 272 206
Polygon -2674135 false false 260 211 260 230 270 228 269 209
Polygon -2674135 false false 239 211 239 230 249 228 248 209
Polygon -955883 true false 262 214 261 219 265 218 265 229 269 229 268 212
Polygon -11221820 true false 241 214 240 219 244 218 244 229 248 229 247 212
Polygon -1 true false 226 217 226 220 222 220 222 217
Polygon -1 true false 264 215 264 218 260 218 260 215
Polygon -1 true false 244 214 244 217 240 217 240 214
Polygon -1184463 true false 25 279 26 259 31 251 35 251 38 259 37 279
Circle -7500403 true true 27 262 8
Polygon -1184463 true false 41 279 42 259 47 251 51 251 54 259 53 279
Circle -1 true false 43 262 8
Polygon -955883 true false 57 279 58 259 63 251 67 251 70 259 69 279
Polygon -955883 true false 72 281 73 261 78 253 82 253 85 261 84 281
Circle -7500403 true true 59 263 8
Circle -1 true false 75 264 8
Polygon -13840069 true false 87 279 88 259 93 251 97 251 100 259 99 279
Polygon -14835848 true false 103 280 104 260 109 252 113 252 116 260 115 280
Circle -1 true false 105 264 8
Circle -1 true false 89 262 8
Polygon -1 true false 141 280 121 280 120 277 120 272 125 270 142 271 142 276 141 277
Polygon -8630108 false false 140 276 125 276 125 274
Polygon -1 true false 146 269 126 269 125 266 125 261 130 259 147 260 147 265 146 266
Polygon -8630108 false false 143 265 128 265 128 263

better shaped till person
false
0
Polygon -7500403 true true 180 195 120 195 105 285 105 300 135 300 150 225 165 300 195 300 195 285
Polygon -1 true false 120 93 105 93 75 195 90 213 120 153 120 198 180 198 180 153 210 213 225 198 195 93 180 93 165 108 150 168 135 108 120 93
Polygon -2674135 true false 120 90 149 141 180 90
Rectangle -7500403 true true 135 76 165 90
Circle -7500403 true true 113 11 74
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Polygon -2674135 true false 145 91 168 79 169 98
Polygon -2674135 true false 155 91 132 79 131 98
Polygon -7500403 true true 226 196 213 150 186 165 210 214 225 198
Polygon -7500403 true true 75 196 87 151 114 166 90 215 76 197

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bread shelf 1
false
0
Rectangle -16777216 true false 47 91 54 255
Polygon -16777216 true false 294 270 249 285 249 300 294 285 294 270
Rectangle -16777216 true false 286 117 295 285
Rectangle -16777216 true false 156 106 165 285
Polygon -6459832 true false 255 195 300 165 45 135 0 165
Polygon -16777216 true false 295 185 251 199 251 204 295 190 295 186 295 186
Polygon -6459832 true false 255 240 300 210 45 180 0 210
Polygon -6459832 true false 255 285 300 255 45 225 0 255
Polygon -16777216 true false 290 272 246 286 246 291 290 277 290 273 290 273
Polygon -16777216 true false 295 231 251 245 251 250 295 236 295 232 295 232
Rectangle -16777216 true false 1 120 9 270
Polygon -6459832 true false 255 150 300 120 45 90 0 120
Polygon -16777216 true false 294 139 250 153 250 158 294 144 294 140 294 140
Line -16777216 false 45 90 300 120
Polygon -16777216 true false 0 255 0 255 255 285 247 301 0 270
Polygon -6459832 true false 45 75 45 90 300 120 300 105
Polygon -16777216 true false 44 77 45 73 297 103 299 107
Polygon -16777216 true false -1 122 0 118 252 148 254 152
Polygon -16777216 true false -1 212 0 208 252 238 254 242
Polygon -16777216 true false -1 167 0 163 252 193 254 197
Polygon -7500403 true true 35 95 35 119 58 120 82 97 79 85 62 79
Polygon -7500403 true true 66 148 66 172 89 173 113 150 110 138 93 132
Polygon -7500403 true true 26 144 26 168 49 169 73 146 70 134 53 128
Polygon -16777216 false false 67 149 109 134 112 151 89 172 88 147 107 135 92 130 68 148 88 149 87 173 67 171
Polygon -16777216 false false 25 145 67 130 70 147 47 168 46 143 65 131 50 126 26 144 46 145 45 169 25 167
Polygon -16777216 false false 34 96 76 81 79 98 56 119 55 94 74 82 59 77 35 95 55 96 54 120 34 118
Polygon -1184463 true false 69 149 69 169 86 171 87 152
Polygon -1184463 true false 26 145 26 165 43 167 44 148
Polygon -1184463 true false 36 97 36 117 53 119 54 100
Polygon -2674135 true false 79 159 64 163 67 167 65 170 73 171 82 175 82 163
Polygon -2674135 true false 34 156 19 160 22 164 20 167 28 168 37 172 37 160
Polygon -2674135 true false 43 107 28 111 31 115 29 118 37 119 46 123 46 111
Polygon -955883 true false 79 158 84 164 84 176 80 170 81 167 78 167 73 171 72 167 78 164 78 163 70 162 71 158
Polygon -955883 true false 35 153 40 159 40 171 36 165 37 162 34 162 29 166 28 162 34 159 34 158 26 157 27 153
Polygon -955883 true false 44 107 49 113 49 125 45 119 46 116 43 116 38 120 37 116 43 113 43 112 35 111 36 107
Polygon -7500403 true true 65 98 65 122 88 123 112 100 109 88 92 82
Polygon -16777216 false false 66 99 108 84 111 101 88 122 87 97 106 85 91 80 67 98 87 99 86 123 66 121
Polygon -1184463 true false 68 101 68 121 85 123 86 104
Polygon -2674135 true false 78 112 63 116 66 120 64 123 72 124 81 128 81 116
Polygon -955883 true false 79 111 84 117 84 129 80 123 81 120 78 120 73 124 72 120 78 117 78 116 70 115 71 111
Polygon -7500403 true true 51 78 51 102 74 103 98 80 95 68 78 62
Polygon -16777216 false false 51 78 93 63 96 80 73 101 72 76 91 64 76 59 52 77 72 78 71 102 51 100
Polygon -1184463 true false 52 78 52 98 69 100 70 81
Polygon -2674135 true false 62 89 47 93 50 97 48 100 56 101 65 105 65 93
Polygon -955883 true false 62 89 67 95 67 107 63 101 64 98 61 98 56 102 55 98 61 95 61 94 53 93 54 89
Polygon -7500403 true true 23 188 23 212 46 213 70 190 67 178 50 172
Polygon -16777216 false false 23 188 65 173 68 190 45 211 44 186 63 174 48 169 24 187 44 188 43 212 23 210
Polygon -13791810 true false 26 189 26 209 43 211 44 192
Polygon -13345367 true false 33 199 18 203 21 207 19 210 27 211 36 215 36 203
Polygon -11221820 true false 35 198 40 204 40 216 36 210 37 207 34 207 29 211 28 207 34 204 34 203 26 202 27 198
Polygon -7500403 true true 47 192 47 216 70 217 94 194 91 182 74 176
Polygon -16777216 false false 47 194 89 179 92 196 69 217 68 192 87 180 72 175 48 193 68 194 67 218 47 216
Polygon -13791810 true false 48 194 48 214 65 216 66 197
Polygon -13345367 true false 58 202 43 206 46 210 44 213 52 214 61 218 61 206
Polygon -11221820 true false 59 202 64 208 64 220 60 214 61 211 58 211 53 215 52 211 58 208 58 207 50 206 51 202
Polygon -7500403 true true 15 233 15 257 38 258 62 235 59 223 42 217
Polygon -16777216 false false 15 234 57 219 60 236 37 257 36 232 55 220 40 215 16 233 36 234 35 258 15 256
Polygon -13791810 true false 17 235 17 255 34 257 35 238
Polygon -13345367 true false 27 244 12 248 15 252 13 255 21 256 30 260 30 248
Polygon -11221820 true false 28 243 33 249 33 261 29 255 30 252 27 252 22 256 21 252 27 249 27 248 19 247 20 243
Polygon -7500403 true true 47 235 47 259 70 260 94 237 91 225 74 219
Polygon -16777216 false false 48 237 90 222 93 239 70 260 69 235 88 223 73 218 49 236 69 237 68 261 48 259
Polygon -13791810 true false 50 238 50 258 67 260 68 241
Polygon -13345367 true false 56 251 41 255 44 259 42 262 50 263 59 267 59 255
Polygon -11221820 true false 57 248 62 254 62 266 58 260 59 257 56 257 51 261 50 257 56 254 56 253 48 252 49 248
Polygon -7500403 true true 93 240 93 264 116 265 140 242 137 230 120 224
Polygon -16777216 false false 93 242 135 227 138 244 115 265 114 240 133 228 118 223 94 241 114 242 113 266 93 264
Polygon -10899396 true false 94 242 94 262 111 264 112 245
Polygon -14835848 true false 99 253 84 257 87 261 85 264 93 265 102 269 102 257
Polygon -1184463 true false 101 256 106 262 106 274 102 268 103 265 100 265 95 269 94 265 102 262 100 261 92 260 93 256
Polygon -7500403 true true 121 242 121 266 144 267 168 244 165 232 148 226
Polygon -16777216 false false 121 243 163 228 166 245 143 266 142 241 161 229 146 224 122 242 142 243 141 267 121 265
Polygon -10899396 true false 124 245 124 265 141 267 142 248
Polygon -14835848 true false 134 256 119 260 122 264 120 267 128 268 137 272 137 260
Polygon -1184463 true false 132 257 137 263 137 275 133 269 134 266 131 266 126 270 125 266 133 263 131 262 123 261 124 257
Polygon -7500403 true true 144 247 144 271 167 272 191 249 188 237 171 231
Polygon -16777216 false false 144 250 186 235 189 252 166 273 165 248 184 236 169 231 145 249 165 250 164 274 144 272
Polygon -10899396 true false 147 252 147 272 164 274 165 255
Polygon -14835848 true false 156 256 141 260 144 264 142 267 150 268 159 272 159 260
Polygon -1184463 true false 159 256 164 262 164 274 160 268 161 265 158 265 153 269 152 265 160 262 158 261 150 260 151 256
Polygon -7500403 true true 127 101 127 125 150 126 174 103 171 91 154 85
Polygon -16777216 false false 151 120 172 102 170 89 156 83 128 99 168 89 146 107
Circle -2674135 true false 122 100 28
Polygon -16777216 true false 133 114 118 118 121 122 119 125 127 126 136 130 136 118
Polygon -955883 true false 136 114 141 120 141 132 137 126 138 123 135 123 130 127 129 123 135 120 135 119 127 118 128 114
Polygon -7500403 true true 149 107 149 131 172 132 196 109 193 97 176 91
Polygon -16777216 false false 175 127 196 109 194 96 180 90 152 106 192 96 170 114
Circle -2674135 true false 147 108 28
Polygon -16777216 true false 160 119 145 123 148 127 146 130 154 131 163 135 163 123
Polygon -955883 true false 162 117 167 123 167 135 163 129 164 126 161 126 156 130 155 126 161 123 161 122 153 121 154 117
Polygon -7500403 true true 107 154 107 178 130 179 154 156 151 144 134 138
Polygon -16777216 false false 131 175 152 157 150 144 136 138 108 154 148 144 126 162
Circle -2064490 true false 103 153 28
Polygon -16777216 true false 116 167 101 171 104 175 102 178 110 179 119 183 119 171
Polygon -5825686 true false 117 167 122 173 122 185 118 179 119 176 116 176 111 180 110 176 118 173 116 172 108 171 109 167
Polygon -7500403 true true 141 160 141 184 164 185 188 162 185 150 168 144
Polygon -16777216 false false 164 181 185 163 183 150 169 144 141 160 181 150 159 168
Circle -2064490 true false 135 160 28
Polygon -16777216 true false 149 171 134 175 137 179 135 182 143 183 152 187 152 175
Polygon -5825686 true false 151 170 156 176 156 188 152 182 153 179 150 179 145 183 144 179 152 176 150 175 142 174 143 170
Polygon -7500403 true true 107 200 107 224 130 225 154 202 151 190 134 184
Polygon -16777216 false false 107 202 149 187 152 204 129 225 128 200 147 188 132 183 108 201 128 202 127 226 107 224
Polygon -10899396 true false 108 203 108 223 125 225 126 206
Polygon -14835848 true false 116 210 101 214 104 218 102 221 110 222 119 226 119 214
Polygon -1184463 true false 117 210 122 216 122 228 118 222 119 219 116 219 111 223 110 219 116 216 116 215 108 214 109 210
Polygon -1 true false 173 193 155 212 155 221 199 228 216 210 216 201
Line -16777216 false 155 213 198 220
Line -16777216 false 198 220 214 203
Line -16777216 false 200 221 200 228
Line -16777216 false 175 194 175 200
Line -16777216 false 176 200 165 215
Line -16777216 false 175 201 208 207
Circle -6459832 true false 192 196 16
Circle -6459832 true false 168 197 16
Circle -6459832 true false 177 202 16
Polygon -7500403 true true 201 109 203 132 249 140 282 122 287 96 247 114
Polygon -10899396 true false 202 110 239 92 285 98 248 114
Line -16777216 false 240 93 239 112
Polygon -1 true false 228 201 210 220 210 229 254 236 271 218 271 209
Line -16777216 false 209 221 253 228
Line -16777216 false 254 228 254 235
Line -16777216 false 255 229 270 210
Line -16777216 false 228 203 229 210
Line -16777216 false 230 211 268 217
Line -16777216 false 229 211 218 223
Circle -6459832 true false 223 204 16
Circle -6459832 true false 240 210 16
Polygon -6459832 true false 227 112 236 88 247 77 259 77 266 85 262 110 245 115
Line -16777216 false 239 89 254 91
Line -16777216 false 237 100 251 100
Line -16777216 false 232 107 249 107
Polygon -7500403 true true 184 252 184 276 207 277 231 254 228 242 211 236
Polygon -16777216 false false 186 255 228 240 231 257 208 278 207 253 226 241 211 236 187 254 207 255 206 279 186 277
Polygon -1184463 true false 188 256 188 276 205 278 206 259
Polygon -14835848 true false 197 265 182 269 185 273 183 276 191 277 200 281 200 269
Polygon -11221820 true false 198 264 203 270 203 282 199 276 200 273 197 273 192 277 191 273 197 270 197 269 189 268 190 264
Polygon -1 true false 212 151 194 170 194 179 238 186 255 168 255 159
Line -16777216 false 195 172 236 177
Line -16777216 false 236 179 236 186
Line -16777216 false 235 177 252 160
Line -16777216 false 211 152 213 162
Line -16777216 false 213 162 203 173
Line -16777216 false 214 162 246 166
Circle -6459832 true false 204 149 32
Polygon -1 true false 207 175 232 178 232 182 208 180
Rectangle -16777216 true false 246 147 254 300
Line -16777216 false 214 156 225 158
Line -16777216 false 209 164 226 166

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building institution
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -16777216 false false 0 60 150 15 300 60
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

car left
false
11
Circle -16777216 true false 93 251 40
Circle -16777216 true false 221 235 40
Polygon -8630108 true true 251 178 222 161 213 158 202 158 151 162 129 167 116 174 94 196 89 200 83 201 65 206 46 211 36 218 30 231 33 254 63 279 79 279 91 278 93 263 101 254 116 249 130 256 135 269 136 274 219 261 220 249 229 238 240 234 256 239 262 251 263 258 266 254 267 245 269 230 270 218 266 202
Polygon -7500403 false false 144 216 147 267 209 257 208 216 205 186 167 189 161 193 157 195
Polygon -7500403 false false 92 202 105 216 122 227 76 243 60 245 39 225 45 214
Polygon -7500403 true false 56 252 60 246 66 246 72 245 86 243 86 249 82 256 62 256
Polygon -7500403 true false 35 231 38 226 43 216 45 213 35 218 31 230
Polygon -16777216 true false 34 230 56 251 61 245 39 225
Circle -7500403 true false 42 232 10
Circle -16777216 true false 44 234 6
Polygon -955883 false false 75 247 76 253 83 249 83 246
Polygon -2674135 false false 58 251 63 247 72 247 75 253 65 254
Circle -1 false false 70 245 6
Polygon -955883 true false 88 244 88 247 93 247 92 243
Polygon -16777216 true false 32 241 53 261 63 266 75 266 75 269 71 274 61 275 33 251
Polygon -8630108 true true 33 248 32 252 34 255 60 276 62 274 36 255 35 252
Polygon -2674135 false false 33 227 37 225 38 221 34 222
Polygon -955883 false false 40 220 36 219 37 217 42 216
Circle -1 false false 37 218 4
Polygon -10899396 true false 36 236 35 243 50 259 50 250
Polygon -5825686 true false 36 240 40 243 43 246 44 251 47 251 43 252 41 247 36 245
Circle -1184463 true false 38 242 4
Circle -1184463 true false 41 247 2
Polygon -16777216 true false 136 172 128 168 115 176 91 200 96 206 108 218 124 228 134 219 146 203 155 190 146 181
Polygon -13791810 true false 135 175 127 170 116 177 93 199 98 206 107 215 123 225 132 218 144 203 152 190 145 183
Polygon -1 true false 109 186 110 184 114 184 119 180 126 182 130 185 133 187 135 190 108 189
Polygon -1 true false 123 197 123 195 125 195 127 195 127 194 134 196 137 194 139 198 139 200 125 199
Polygon -16777216 true false 94 199 105 208 106 213 103 212 103 209 95 202
Polygon -16777216 true false 109 211 120 220 121 225 118 224 118 221 110 214
Polygon -16777216 true false 143 228 137 226 137 223 158 193 165 189 220 182 244 183 247 185 255 197 258 208 254 210 210 218
Polygon -13791810 true false 144 216 158 196 164 192 172 190 203 187 206 190 208 210 207 217 145 226 139 225
Polygon -13791810 true false 211 210 209 189 210 187 213 186 243 185 248 190 254 199 256 207 250 209 215 215 213 214
Polygon -1 true false 185 203 185 201 187 201 189 201 189 200 196 202 199 200 201 204 201 206 187 205
Polygon -1 true false 232 203 232 201 234 201 236 201 236 200 243 202 246 200 248 204 248 206 234 205
Polygon -16777216 true false 163 205 169 201 174 204 176 200 183 202 177 202 174 205 169 203
Polygon -16777216 true false 154 212 160 208 165 211 167 207 174 209 168 209 165 212 160 210
Polygon -2674135 true false 267 210 271 212 271 220 269 221 267 215 266 209
Circle -7500403 false false 193 226 8
Polygon -16777216 true false 194 232 194 229 203 228 203 231
Polygon -16777216 true false 151 225 150 208 138 225 145 227
Polygon -16777216 true false 143 221 146 220 153 216 162 221 162 229
Line -7500403 false 150 219 161 222
Line -7500403 false 151 219 145 222
Circle -7500403 false false 102 259 24
Circle -7500403 true false 102 259 23
Circle -16777216 true false 110 259 10
Circle -16777216 true false 107 272 10
Circle -16777216 true false 102 264 10
Circle -16777216 true false 115 267 10
Circle -7500403 false false 107 264 14
Circle -7500403 true false 230 243 23
Circle -16777216 true false 230 247 10
Circle -16777216 true false 234 256 10
Circle -16777216 true false 243 252 10
Circle -16777216 true false 239 243 10
Circle -7500403 false false 230 243 24
Circle -7500403 false false 235 248 14

car park accacia
false
0
Polygon -16777216 true false 135 240 125 243 84 263 86 290 93 298 232 299 242 294 251 270 240 258 203 241
Polygon -7500403 true true 90 267 98 285 141 288 225 287 241 271 234 259 203 248 165 244 123 252
Polygon -6459832 true false 210 57 227 47 231 50 214 59
Polygon -6459832 true false 146 33 149 43 149 51 155 51 155 41 151 32
Polygon -14835848 true false 183 49 170 48 161 41 167 34 179 32 199 35 211 28 230 31 239 41 258 47 265 57 255 58 237 58 232 52 220 50 211 51 197 56 189 51
Polygon -14835848 true false 103 31 90 30 81 23 87 16 99 14 119 17 131 10 150 13 159 23 178 29 185 39 175 40 157 40 152 34 140 32 131 33 117 38 109 33
Polygon -7500403 true true 148 32 152 40 153 50 154 51 154 41 151 33
Polygon -6459832 true false 151 268 181 268 182 239 176 211 160 185 152 159 160 146 174 134 191 135 217 124 232 111 240 103 263 94 269 84 262 82 257 92 238 97 229 104 219 111 207 123 194 128 182 128 168 127 156 134 163 115 173 103 183 93 190 79 184 79 174 96 161 108 152 124 145 138 143 149 139 158 140 171 131 166 129 151 131 143 126 136 121 126 120 115 124 102 135 89 150 81 156 73 148 74 144 80 132 86 125 89 128 85 128 76 125 73 119 75 123 81 121 88 122 96 116 108 115 121 114 128 107 121 99 110 91 100 89 86 84 69 71 65 59 66 71 72 79 76 83 99 94 116 106 132 115 138 122 146 122 155 126 173 135 182 145 190 151 209 155 228 155 242 153 262
Polygon -7500403 true true 173 267 174 236 169 215 157 191 149 164 151 149 165 135 177 132 158 147 152 160 155 172 160 187 175 210 179 228 181 240 179 266
Polygon -7500403 true true 138 171 132 166 130 155 131 145 119 127 121 106 122 102 133 90 149 82 155 73 152 74 148 79 131 88 127 93 120 101 118 126 121 136 129 148 129 153 131 164
Polygon -7500403 true true 69 65 83 70 91 88 91 98 103 117 115 129 109 128 101 117 91 105 89 94 89 88 85 77 81 72
Polygon -7500403 true true 125 74 129 79 129 85 126 88 128 81 125 78
Polygon -7500403 true true 188 81 181 94 175 99 172 104 164 113 155 135 156 127 162 112 171 102 179 95 182 92
Polygon -7500403 true true 268 84 259 96 244 100 240 103 227 115 216 124 199 131 216 122 230 110 238 101 245 98 257 95
Polygon -10899396 true false 67 74 48 79 28 71 16 59 7 60 9 50 25 47 43 43 59 35 71 19 107 17 131 37 133 51 141 54 152 48 178 29 203 41 216 57 247 55 259 45 270 46 277 58 290 67 304 78 299 90 282 93 266 91 266 85 261 84 257 91 240 90 237 82 235 75 231 72 214 78 211 87 208 89 201 91 192 89 189 84 186 79 178 82 171 83 166 81 159 80 156 76 148 76 143 77 137 80 127 77 124 75 112 77 100 79 91 73 84 70 84 70 72 67 64 67
Polygon -14835848 true false 58 46 59 34 69 20 86 19 94 12 119 17 124 23 122 29 122 25 118 18 96 16 82 24 71 23 68 29 63 34 64 38
Polygon -14835848 true false 8 54 15 48 31 47 49 53 51 57 50 58 46 56 33 51 24 51 16 53
Polygon -14835848 true false 84 61 90 49 104 44 119 44 134 51 143 55 144 61 140 56 128 54 119 48 105 48 92 51
Polygon -14835848 true false 158 49 175 35 188 37 199 40 213 52 221 51 217 56 210 54 200 45 197 41 190 39 172 41
Polygon -14835848 true false 289 66 282 60 266 59 248 65 246 69 247 70 251 68 264 63 273 63 281 65
Polygon -13840069 true false 129 267 124 256 127 249 127 256 131 260 133 256 133 253 138 257 137 267 146 267 146 262 144 258 149 264 150 266 150 255 157 248 152 257 154 261 159 260 159 253 163 261 162 267 171 260 170 256 176 260 172 266 185 266 179 255 188 250 183 255 189 268
Polygon -13840069 true false 227 278 232 267 229 260 229 267 225 271 223 267 223 264 218 268 219 278 210 278 210 273 212 269 207 275 206 277 206 266 199 259 204 268 202 272 197 271 197 264 193 272 194 278 185 271 186 267 180 271 184 277 171 277 177 266 168 261 173 266 167 279
Polygon -13840069 true false 102 282 97 271 100 264 100 271 104 275 106 271 106 268 111 272 110 282 119 282 119 277 117 273 122 279 123 281 123 270 130 263 125 272 127 276 132 275 132 268 136 276 135 282 144 275 143 271 149 275 145 281 158 281 152 270 161 265 156 270 162 283

car right
false
11
Circle -16777216 true false 167 251 40
Circle -16777216 true false 39 235 40
Polygon -8630108 true true 49 178 78 161 87 158 98 158 149 162 171 167 184 174 206 196 211 200 217 201 235 206 254 211 264 218 270 231 267 254 237 279 221 279 209 278 207 263 199 254 184 249 170 256 165 269 164 274 81 261 80 249 71 238 60 234 44 239 38 251 37 258 34 254 33 245 31 230 30 218 34 202
Polygon -7500403 false false 156 216 153 267 91 257 92 216 95 186 133 189 139 193 143 195
Polygon -7500403 false false 208 202 195 216 178 227 224 243 240 245 261 225 255 214
Polygon -7500403 true false 244 252 240 246 234 246 228 245 214 243 214 249 218 256 238 256
Polygon -7500403 true false 265 231 262 226 257 216 255 213 265 218 269 230
Polygon -16777216 true false 266 230 244 251 239 245 261 225
Circle -7500403 true false 248 232 10
Circle -16777216 true false 250 234 6
Polygon -955883 false false 225 247 224 253 217 249 217 246
Polygon -2674135 false false 242 251 237 247 228 247 225 253 235 254
Circle -1 false false 224 245 6
Polygon -955883 true false 212 244 212 247 207 247 208 243
Polygon -16777216 true false 268 241 247 261 237 266 225 266 225 269 229 274 239 275 267 251
Polygon -8630108 true true 267 248 268 252 266 255 240 276 238 274 264 255 265 252
Polygon -2674135 false false 267 227 263 225 262 221 266 222
Polygon -955883 false false 260 220 264 219 263 217 258 216
Circle -1 false false 259 218 4
Polygon -10899396 true false 264 236 265 243 250 259 250 250
Polygon -5825686 true false 264 240 260 243 257 246 256 251 253 251 257 252 259 247 264 245
Circle -1184463 true false 258 242 4
Circle -1184463 true false 257 247 2
Polygon -16777216 true false 164 172 172 168 185 176 209 200 204 206 192 218 176 228 166 219 154 203 145 190 154 181
Polygon -13791810 true false 165 175 173 170 184 177 207 199 202 206 193 215 177 225 168 218 156 203 148 190 155 183
Polygon -1 true false 191 186 190 184 186 184 181 180 174 182 170 185 167 187 165 190 192 189
Polygon -1 true false 177 197 177 195 175 195 173 195 173 194 166 196 163 194 161 198 161 200 175 199
Polygon -16777216 true false 206 199 195 208 194 213 197 212 197 209 205 202
Polygon -16777216 true false 191 211 180 220 179 225 182 224 182 221 190 214
Polygon -16777216 true false 157 228 163 226 163 223 142 193 135 189 80 182 56 183 53 185 45 197 42 208 46 210 90 218
Polygon -13791810 true false 156 216 142 196 136 192 128 190 97 187 94 190 92 210 93 217 155 226 161 225
Polygon -13791810 true false 89 210 91 189 90 187 87 186 57 185 52 190 46 199 44 207 50 209 85 215 87 214
Polygon -1 true false 115 203 115 201 113 201 111 201 111 200 104 202 101 200 99 204 99 206 113 205
Polygon -1 true false 68 203 68 201 66 201 64 201 64 200 57 202 54 200 52 204 52 206 66 205
Polygon -16777216 true false 137 205 131 201 126 204 124 200 117 202 123 202 126 205 131 203
Polygon -16777216 true false 146 212 140 208 135 211 133 207 126 209 132 209 135 212 140 210
Polygon -2674135 true false 33 210 29 212 29 220 31 221 33 215 34 209
Circle -7500403 false false 99 226 8
Polygon -16777216 true false 106 232 106 229 97 228 97 231
Polygon -16777216 true false 149 225 150 208 162 225 155 227
Polygon -16777216 true false 157 221 154 220 147 216 138 221 138 229
Line -7500403 false 150 219 139 222
Line -7500403 false 149 219 155 222
Circle -7500403 false false 174 259 24
Circle -7500403 true false 175 259 23
Circle -16777216 true false 180 259 10
Circle -16777216 true false 183 272 10
Circle -16777216 true false 188 264 10
Circle -16777216 true false 175 267 10
Circle -7500403 false false 179 264 14
Circle -7500403 true false 47 243 23
Circle -16777216 true false 60 247 10
Circle -16777216 true false 56 256 10
Circle -16777216 true false 47 252 10
Circle -16777216 true false 51 243 10
Circle -7500403 false false 46 243 24
Circle -7500403 false false 51 248 14

cereal shelf
false
0
Polygon -7500403 true true 0 180 0 285 45 300 135 300 135 195 135 180
Polygon -16777216 true false 0 270 45 285 45 300 0 285 0 270
Rectangle -16777216 true false 45 285 180 300
Rectangle -16777216 true false 136 181 145 285
Rectangle -16777216 true false 0 181 9 285
Polygon -6459832 true false 45 195 0 180 150 180 180 195
Rectangle -16777216 true false 49 195 180 200
Polygon -16777216 true false 1 181 45 195 45 200 1 186 1 182 1 182
Polygon -6459832 true false 45 240 0 225 150 225 180 240
Polygon -6459832 true false 45 285 0 270 150 270 180 285
Rectangle -1 true false 66 195 84 200
Rectangle -1 true false 93 195 111 200
Rectangle -16777216 true false 45 240 180 245
Rectangle -1 true false 58 240 76 245
Rectangle -1 true false 94 240 112 245
Rectangle -16777216 true false 45 285 180 290
Rectangle -1 true false 57 285 75 290
Rectangle -1 true false 129 285 147 290
Polygon -16777216 true false 1 271 45 285 45 290 1 276 1 272 1 272
Polygon -16777216 true false 1 226 45 240 45 245 1 231 1 227 1 227
Rectangle -16777216 true false 165 196 174 300
Polygon -955883 true false 111 205 139 206 137 210 143 214 143 233 140 233 105 233 105 219 107 213 114 210
Polygon -1184463 true false 131 210 159 211 157 215 163 219 163 238 160 238 125 238 125 224 127 218 134 215
Polygon -955883 false false 132 210 136 218 139 221 140 239 127 237 127 219 133 216
Polygon -1 true false 143 228 147 234 156 234 159 228
Polygon -6459832 true false 147 228 147 226 151 225 151 224 155 224 155 227 157 226 158 227
Circle -2674135 true false 145 224 6
Polygon -5825686 true false 77 201 105 202 103 206 109 210 109 229 106 229 71 229 71 215 73 209 80 206
Polygon -2064490 true false 88 209 116 210 114 214 120 218 120 237 117 237 82 237 82 223 84 217 91 214
Polygon -5825686 false false 89 208 93 216 96 219 97 237 84 235 84 217 90 214
Polygon -1 true false 101 228 105 234 114 234 117 228
Polygon -6459832 true false 103 229 103 227 107 226 107 225 111 225 111 228 113 227 114 228
Circle -2674135 true false 108 224 6
Polygon -13345367 true false 33 201 61 202 59 206 65 210 65 229 62 229 27 229 27 215 29 209 36 206
Polygon -11221820 true false 47 208 75 209 73 213 79 217 79 236 76 236 41 236 41 222 43 216 50 213
Polygon -13345367 false false 49 208 53 216 56 219 57 237 44 235 44 217 50 214
Polygon -1 true false 59 226 63 232 72 232 75 226
Polygon -6459832 true false 63 227 63 225 67 224 67 223 71 223 71 226 73 225 74 226
Circle -2674135 true false 61 222 6
Rectangle -1 true false 126 240 144 245
Polygon -1184463 true false 83 277 76 273 77 247 99 247 107 251 107 277
Polygon -955883 true false 83 250 107 250 107 277 83 277
Polygon -13840069 true false 117 277 110 273 111 247 133 247 141 251 141 277
Polygon -14835848 true false 118 250 142 250 142 277 118 277
Polygon -1184463 true false 94 283 87 279 88 253 110 253 118 257 118 283
Polygon -13840069 true false 130 283 123 279 124 253 146 253 154 257 154 283
Polygon -14835848 true false 131 256 155 256 155 283 131 283
Polygon -955883 true false 94 257 118 257 118 284 94 284
Polygon -1 true false 38 277 31 273 32 247 54 247 62 251 62 277
Polygon -2674135 true false 38 251 62 251 62 278 38 278
Polygon -1 true false 53 284 46 280 47 254 69 254 77 258 77 284
Polygon -2674135 true false 53 257 77 257 77 284 53 284
Rectangle -1 true false 93 285 111 290
Polygon -11221820 true false 97 267 101 273 110 273 113 267
Polygon -11221820 true false 134 267 138 273 147 273 150 267
Polygon -11221820 true false 56 267 60 273 69 273 72 267
Polygon -7500403 true true 136 268 139 264 143 267 146 263 148 267
Polygon -2064490 true false 58 268 61 264 65 267 68 263 70 267
Polygon -1184463 true false 98 268 101 264 105 267 108 263 110 267
Rectangle -16777216 true false 45 196 54 300
Polygon -2064490 true false 116 184 109 180 110 154 132 154 140 158 140 184
Polygon -13345367 true false 117 157 141 157 141 184 117 184
Polygon -2064490 true false 129 190 122 186 123 160 145 160 153 164 153 190
Polygon -13345367 true false 130 164 154 164 154 191 130 191
Polygon -1 true false 81 183 74 179 75 153 97 153 105 157 105 183
Polygon -2064490 true false 82 156 106 156 106 183 82 183
Polygon -1 true false 92 190 85 186 86 160 108 160 116 164 116 190
Polygon -2064490 true false 92 164 116 164 116 191 92 191
Polygon -2064490 true false 43 184 36 180 37 154 59 154 67 158 67 184
Polygon -11221820 true false 44 158 68 158 68 185 44 185
Polygon -2064490 true false 55 191 48 187 49 161 71 161 79 165 79 191
Polygon -11221820 true false 55 165 79 165 79 192 55 192
Polygon -1184463 true false 133 180 137 186 146 186 149 180
Polygon -1184463 true false 58 181 62 187 71 187 74 181
Polygon -1184463 true false 97 180 101 186 110 186 113 180
Polygon -5825686 true false 65 179 62 177 58 179 58 183 61 186 63 184 62 183 62 181 65 181 67 179 72 176 73 176 74 179 74 185 71 183 71 179 68 181 68 185 66 184
Circle -5825686 true false 63 173 7
Polygon -5825686 true false 139 178 136 176 132 178 132 182 135 185 137 183 136 182 136 180 139 180 141 178 146 175 147 175 148 178 148 184 145 182 145 178 142 180 142 184 140 183
Polygon -5825686 true false 103 178 100 176 96 178 96 182 99 185 101 183 100 182 100 180 103 180 105 178 110 175 111 175 112 178 112 184 109 182 109 178 106 180 106 184 104 183
Circle -5825686 true false 137 172 7
Circle -5825686 true false 101 173 7
Circle -1 true false 61 173 4
Circle -1 true false 141 171 4
Circle -1 true false 136 172 4
Circle -1 true false 105 172 4
Circle -1 true false 101 173 4
Circle -1 true false 67 173 4
Circle -16777216 true false 63 173 2
Circle -16777216 true false 63 173 2
Circle -16777216 true false 63 173 2
Circle -16777216 true false 63 173 2
Circle -16777216 true false 101 173 2
Circle -16777216 true false 67 173 2
Circle -16777216 true false 67 173 2
Circle -16777216 true false 67 173 2
Circle -16777216 true false 101 173 2
Circle -16777216 true false 101 173 2
Circle -16777216 true false 101 173 2
Circle -16777216 true false 107 171 2
Circle -16777216 true false 107 171 2
Circle -16777216 true false 107 171 2
Circle -16777216 true false 107 171 2
Circle -16777216 true false 135 172 2
Circle -16777216 true false 135 172 2
Circle -16777216 true false 135 172 2
Circle -16777216 true false 135 172 2
Circle -16777216 true false 141 171 2
Circle -16777216 true false 141 171 2
Circle -16777216 true false 141 171 2
Circle -16777216 true false 141 171 2
Circle -16777216 true false 64 176 2
Circle -16777216 true false 64 176 2
Circle -16777216 true false 64 176 2
Circle -16777216 true false 64 176 2
Circle -16777216 true false 104 176 2
Circle -16777216 true false 104 176 2
Circle -16777216 true false 104 176 2
Circle -16777216 true false 104 176 2
Circle -16777216 true false 140 175 2
Circle -16777216 true false 140 175 2
Circle -16777216 true false 140 175 2
Circle -16777216 true false 140 175 2
Rectangle -1 true false 123 195 141 200

chip shelf
false
0
Polygon -7500403 true true 0 180 0 285 45 300 255 300 255 195 255 180
Polygon -16777216 true false 0 270 45 285 45 300 0 285 0 270
Rectangle -16777216 true false 45 285 300 300
Rectangle -16777216 true false 121 181 130 285
Rectangle -16777216 true false 0 181 9 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 45 195 0 180 255 180 300 195
Rectangle -16777216 true false 45 195 300 200
Polygon -16777216 true false 1 181 45 195 45 200 1 186 1 182 1 182
Polygon -6459832 true false 45 240 0 225 255 225 300 240
Polygon -6459832 true false 45 285 0 270 255 270 300 285
Rectangle -1 true false 58 195 76 200
Rectangle -1 true false 108 195 126 200
Rectangle -16777216 true false 45 240 300 245
Rectangle -1 true false 66 240 84 245
Rectangle -1 true false 108 240 126 245
Rectangle -1 true false 192 240 210 245
Rectangle -16777216 true false 45 285 300 290
Rectangle -1 true false 66 285 84 290
Rectangle -1 true false 108 285 126 290
Rectangle -1 true false 192 285 210 290
Polygon -16777216 true false 1 271 45 285 45 290 1 276 1 272 1 272
Polygon -16777216 true false 1 226 45 240 45 245 1 231 1 227 1 227
Rectangle -16777216 true false 291 196 300 300
Rectangle -1 true false 237 285 255 290
Rectangle -1 true false 237 240 255 245
Rectangle -1 true false 237 195 255 200
Polygon -13345367 true false 215 203 246 201 253 205 247 212 255 220 253 226 250 234 216 235 215 227 217 217 218 214 213 205
Polygon -1 true false 217 204 221 213 217 225 218 234 225 232 225 213
Polygon -13345367 true false 237 205 268 203 275 207 269 214 277 222 275 228 272 236 238 237 237 229 239 219 240 216 235 207
Polygon -1 true false 241 203 245 212 241 224 242 233 249 231 249 212
Circle -1184463 true false 252 209 10
Circle -1184463 true false 229 218 10
Circle -1184463 true false 228 207 10
Circle -1184463 true false 251 222 10
Circle -1184463 true false 262 217 10
Polygon -2674135 true false 174 203 205 201 212 205 206 212 214 220 212 226 209 234 175 235 174 227 176 217 177 214 172 205
Polygon -1 true false 175 206 179 215 175 227 176 236 183 234 183 215
Circle -1184463 true false 197 214 10
Circle -1184463 true false 187 221 10
Circle -1184463 true false 187 207 10
Polygon -2674135 true false 192 204 223 202 230 206 224 213 232 221 230 227 227 235 193 236 192 228 194 218 195 215 190 206
Polygon -1 true false 194 206 198 215 194 227 195 236 202 234 202 215
Circle -1184463 true false 203 208 10
Circle -1184463 true false 216 216 10
Circle -1184463 true false 205 222 10
Polygon -13840069 true false 126 202 157 200 164 204 158 211 166 219 164 225 161 233 127 234 126 226 128 216 129 213 124 204
Polygon -1 true false 129 204 133 213 129 225 130 234 137 232 137 213
Circle -1184463 true false 138 218 10
Circle -1184463 true false 148 213 10
Circle -1184463 true false 137 204 10
Polygon -13840069 true false 145 205 176 203 183 207 177 214 185 222 183 228 180 236 146 237 145 229 147 219 148 216 143 207
Polygon -1 true false 146 206 150 215 146 227 147 236 154 234 154 215
Circle -1184463 true false 155 221 10
Circle -1184463 true false 167 214 10
Circle -1184463 true false 156 207 10
Polygon -11221820 true false 81 201 112 199 119 203 113 210 121 218 119 224 116 232 82 233 81 225 83 215 84 212 79 203
Polygon -1 true false 82 203 86 212 82 224 83 233 90 231 90 212
Polygon -955883 true false 99 217 95 225 105 227
Polygon -955883 true false 108 211 104 219 114 221
Polygon -955883 true false 97 206 93 214 103 216
Polygon -11221820 true false 102 206 133 204 140 208 134 215 142 223 140 229 137 237 103 238 102 230 104 220 105 217 100 208
Polygon -1 true false 107 207 111 216 107 228 108 237 115 235 115 216
Polygon -955883 true false 130 217 126 225 136 227
Polygon -955883 true false 119 220 115 228 125 230
Polygon -955883 true false 122 207 118 215 128 217
Polygon -1184463 true false 40 202 71 200 78 204 72 211 80 219 78 225 75 233 41 234 40 226 42 216 43 213 38 204
Polygon -1 true false 40 203 44 212 40 224 41 233 48 231 48 212
Polygon -955883 true false 61 219 57 227 67 229
Polygon -955883 true false 68 210 64 218 74 220
Polygon -955883 true false 58 203 54 211 64 213
Polygon -1184463 true false 62 206 93 204 100 208 94 215 102 223 100 229 97 237 63 238 62 230 64 220 65 217 60 208
Polygon -1 true false 62 205 66 214 62 226 63 235 70 233 70 214
Polygon -955883 true false 89 216 85 224 95 226
Polygon -955883 true false 80 220 76 228 86 230
Polygon -955883 true false 80 206 76 214 86 216
Polygon -1 true false 215 154 246 152 253 156 247 163 255 171 253 177 250 185 216 186 215 178 217 168 218 165 213 156
Polygon -6459832 true false 234 163 229 161 224 161 222 165 224 171 229 174 234 176 242 174 244 170 245 166 244 161 240 161 236 163 235 166
Polygon -1 true false 231 173 234 169 238 173
Polygon -1 true false 237 167 240 171 243 168 243 165 240 164
Polygon -1 true false 232 167 229 171 226 168 226 165 229 164
Polygon -1 true false 232 167 229 171 226 168 226 165 229 164
Polygon -2064490 true false 215 155 219 164 215 176 216 185 223 183 223 164
Polygon -1 true false 242 158 273 156 280 160 274 167 282 175 280 181 277 189 243 190 242 182 244 172 245 169 240 160
Polygon -2064490 true false 242 158 246 167 242 179 243 188 250 186 250 167
Polygon -6459832 true false 263 171 258 169 253 169 251 173 253 179 258 182 263 184 271 182 273 178 274 174 273 169 269 169 265 171 264 174
Polygon -1 true false 261 175 258 179 255 176 255 173 258 172
Polygon -1 true false 260 180 263 176 267 180
Polygon -1 true false 265 174 268 178 271 175 271 172 268 171
Polygon -1 true false 176 154 207 152 214 156 208 163 216 171 214 177 211 185 177 186 176 178 178 168 179 165 174 156
Polygon -2064490 true false 178 156 182 165 178 177 179 186 186 184 186 165
Polygon -6459832 true false 198 166 193 164 188 164 186 168 188 174 193 177 198 179 206 177 208 173 209 169 208 164 204 164 200 166 199 169
Polygon -1 true false 196 170 193 174 190 171 190 168 193 167
Polygon -1 true false 195 176 198 172 202 176
Polygon -1 true false 198 161 229 159 236 163 230 170 238 178 236 184 233 192 199 193 198 185 200 175 201 172 196 163
Polygon -2064490 true false 199 163 203 172 199 184 200 193 207 191 207 172
Polygon -6459832 true false 220 175 215 173 210 173 208 177 210 183 215 186 220 188 228 186 230 182 231 178 230 173 226 173 222 175 221 178
Polygon -1 true false 218 179 215 183 212 180 212 177 215 176
Polygon -1 true false 222 179 225 183 228 180 228 177 225 176
Polygon -1 true false 217 185 220 181 224 185
Polygon -1 true false 133 155 164 153 171 157 165 164 173 172 171 178 168 186 134 187 133 179 135 169 136 166 131 157
Polygon -10899396 true false 135 157 139 166 135 178 136 187 143 185 143 166
Polygon -6459832 true false 156 161 158 160 168 178 167 179
Polygon -6459832 true false 148 162 150 161 160 179 159 180
Polygon -6459832 true false 150 159 152 158 160 172 158 173
Polygon -6459832 true false 143 162 145 161 155 179 154 180
Polygon -1 true false 154 161 185 159 192 163 186 170 194 178 192 184 189 192 155 193 154 185 156 175 157 172 152 163
Polygon -10899396 true false 156 161 160 170 156 182 157 191 164 189 164 170
Polygon -6459832 true false 166 172 168 171 178 189 177 190
Polygon -6459832 true false 167 167 169 166 179 184 178 185
Polygon -6459832 true false 174 167 176 166 186 184 185 185
Polygon -13345367 true false 208 249 239 247 246 251 240 258 248 266 246 272 243 280 209 281 208 273 210 263 211 260 206 251
Polygon -1 true false 211 250 215 259 211 271 212 280 219 278 219 259
Circle -1184463 true false 222 268 10
Circle -1184463 true false 231 260 10
Circle -1184463 true false 221 251 10
Polygon -13345367 true false 233 253 264 251 271 255 265 262 273 270 271 276 268 284 234 285 233 277 235 267 236 264 231 255
Polygon -1 true false 235 254 239 263 235 275 236 284 243 282 243 263
Circle -1184463 true false 245 268 10
Circle -1184463 true false 257 269 10
Circle -1184463 true false 247 257 10
Polygon -2674135 true false 165 248 196 246 203 250 197 257 205 265 203 271 200 279 166 280 165 272 167 262 168 259 163 250
Polygon -1 true false 166 250 170 259 166 271 167 280 174 278 174 259
Circle -1184463 true false 187 259 10
Circle -1184463 true false 176 263 10
Circle -1184463 true false 177 249 10
Polygon -2674135 true false 187 252 218 250 225 254 219 261 227 269 225 275 222 283 188 284 187 276 189 266 190 263 185 254
Polygon -1 true false 189 251 193 260 189 272 190 281 197 279 197 260
Circle -1184463 true false 211 266 10
Circle -1184463 true false 199 269 10
Circle -1184463 true false 202 254 10
Polygon -13840069 true false 122 248 153 246 160 250 154 257 162 265 160 271 157 279 123 280 122 272 124 262 125 259 120 250
Polygon -1 true false 123 249 127 258 123 270 124 279 131 277 131 258
Circle -1184463 true false 144 259 10
Circle -1184463 true false 132 265 10
Circle -1184463 true false 133 249 10
Polygon -13840069 true false 142 254 173 252 180 256 174 263 182 271 180 277 177 285 143 286 142 278 144 268 145 265 140 256
Polygon -1 true false 143 255 147 264 143 276 144 285 151 283 151 264
Circle -1184463 true false 165 265 10
Circle -1184463 true false 153 270 10
Circle -1184463 true false 155 256 10
Polygon -11221820 true false 85 246 116 244 123 248 117 255 125 263 123 269 120 277 86 278 85 270 87 260 88 257 83 248
Polygon -1 true false 85 246 89 255 85 267 86 276 93 274 93 255
Polygon -955883 true false 110 255 106 263 116 265
Polygon -955883 true false 100 260 96 268 106 270
Polygon -955883 true false 100 247 96 255 106 257
Polygon -11221820 true false 100 253 131 251 138 255 132 262 140 270 138 276 135 284 101 285 100 277 102 267 103 264 98 255
Polygon -1 true false 102 254 106 263 102 275 103 284 110 282 110 263
Polygon -955883 true false 127 265 123 273 133 275
Polygon -955883 true false 116 268 112 276 122 278
Polygon -955883 true false 121 255 117 263 127 265
Polygon -1184463 true false 25 246 56 244 63 248 57 255 65 263 63 269 60 277 26 278 25 270 27 260 28 257 23 248
Polygon -1 true false 26 247 30 256 26 268 27 277 34 275 34 256
Polygon -955883 true false 51 260 47 268 57 270
Polygon -955883 true false 40 261 36 269 46 271
Polygon -955883 true false 44 250 40 258 50 260
Polygon -1184463 true false 53 249 84 247 91 251 85 258 93 266 91 272 88 280 54 281 53 273 55 263 56 260 51 251
Polygon -1 true false 54 250 58 259 54 271 55 280 62 278 62 259
Polygon -955883 true false 82 262 78 270 88 272
Polygon -955883 true false 68 263 64 271 74 273
Polygon -955883 true false 72 250 68 258 78 260
Polygon -16777216 true false 99 167 122 168 120 172 123 178 124 186 119 188 102 189 99 182 99 174 103 171
Polygon -13840069 true false 108 173 112 170 120 179 114 182
Polygon -1 true false 101 168 104 172 100 175 100 182 102 187 104 186 105 176 105 172
Polygon -16777216 true false 119 171 142 172 140 176 143 182 144 190 139 192 122 193 119 186 119 178 123 175
Polygon -13840069 true false 128 178 132 175 140 184 134 187
Polygon -1 true false 122 173 125 177 121 180 121 187 123 192 125 191 126 181 126 177
Polygon -16777216 true false 72 162 95 163 93 167 96 173 97 181 92 183 75 184 72 177 72 169 76 166
Polygon -1 true false 74 163 77 167 73 170 73 177 75 182 77 181 78 171 78 167
Polygon -13840069 true false 81 170 85 167 93 176 87 179
Polygon -16777216 true false 84 171 107 172 105 176 108 182 109 190 104 192 87 193 84 186 84 178 88 175
Polygon -1 true false 88 174 91 178 87 181 87 188 89 193 91 192 92 182 92 178
Polygon -13840069 true false 94 179 98 176 106 185 100 188
Rectangle -16777216 true false 169 198 178 302
Rectangle -16777216 true false 45 196 54 300
Rectangle -1 true false 162 195 180 200
Polygon -16777216 true false 44 164 67 165 65 169 68 175 69 183 64 185 47 186 44 179 44 171 48 168
Polygon -955883 true false 53 172 57 169 65 178 59 181
Polygon -16777216 true false 61 170 84 171 82 175 85 181 86 189 81 191 64 192 61 185 61 177 65 174
Polygon -1 true false 47 165 50 169 46 172 46 179 48 184 50 183 51 173 51 169
Polygon -1 true false 64 172 67 176 63 179 63 186 65 191 67 190 68 180 68 176
Polygon -955883 true false 71 178 75 175 83 184 77 187
Polygon -16777216 true false 17 163 40 164 38 168 41 174 42 182 37 184 20 185 17 178 17 170 21 167
Polygon -1 true false 21 164 24 168 20 171 20 178 22 183 24 182 25 172 25 168
Polygon -955883 true false 27 171 31 168 39 177 33 180
Polygon -16777216 true false 34 170 57 171 55 175 58 181 59 189 54 191 37 192 34 185 34 177 38 174
Polygon -1 true false 37 172 40 176 36 179 36 186 38 191 40 190 41 180 41 176
Polygon -955883 true false 42 178 46 175 54 184 48 187

chocolate shelf
false
0
Rectangle -7500403 true true 45 180 255 300
Rectangle -16777216 true false 1 285 301 300
Rectangle -16777216 true false 45 181 54 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 0 195 45 180 255 180 300 195
Rectangle -16777216 true false 0 195 300 200
Rectangle -1 true false 36 195 54 200
Rectangle -1 true false 93 195 111 200
Rectangle -1 true false 177 195 195 200
Polygon -6459832 true false 0 240 45 225 255 225 300 240
Polygon -6459832 true false 0 285 45 270 255 270 300 285
Rectangle -16777216 true false 0 285 300 290
Rectangle -16777216 true false 0 240 300 245
Rectangle -1 true false 36 240 54 245
Rectangle -1 true false 93 240 111 245
Rectangle -1 true false 66 285 84 290
Rectangle -1 true false 236 285 254 290
Rectangle -16777216 true false 0 196 9 300
Rectangle -16777216 true false 291 196 300 300
Rectangle -1 true false 222 195 240 200
Rectangle -1 true false 177 240 195 245
Rectangle -1 true false 189 285 207 290
Polygon -8630108 true false 269 179 269 191 169 192 155 185 156 149 252 148 269 180
Polygon -16777216 true false 250 152 265 182 165 182 161 154
Polygon -1 true false 31 179 31 191 131 192 145 185 144 149 48 148 31 180
Polygon -16777216 true false 50 152 35 182 135 182 139 154
Polygon -8630108 true false 249 156 260 178 245 177 237 157
Polygon -1 true false 124 157 113 179 128 178 136 158
Polygon -1 true false 106 157 95 179 110 178 118 158
Polygon -1 true false 88 156 77 178 92 177 100 157
Polygon -1 true false 69 156 58 178 73 177 81 157
Polygon -1 true false 51 156 40 178 55 177 63 157
Polygon -8630108 true false 177 157 188 179 173 178 165 158
Polygon -8630108 true false 195 157 206 179 191 178 183 158
Polygon -8630108 true false 213 156 224 178 209 177 201 157
Polygon -8630108 true false 231 157 242 179 227 178 219 158
Polygon -6459832 true false 62 175 65 169 68 170 69 166 73 167 72 173 67 171 67 175
Polygon -6459832 true false 116 175 119 169 122 170 123 166 127 167 126 173 121 171 121 175
Polygon -6459832 true false 98 175 101 169 104 170 105 166 109 167 108 173 103 171 103 175
Polygon -6459832 true false 81 176 84 170 87 171 88 167 92 168 91 174 86 172 86 176
Polygon -6459832 true false 43 175 46 169 49 170 50 166 54 167 53 173 48 171 48 175
Circle -955883 true false 50 162 7
Polygon -14835848 true false 73 159 69 161 69 165 75 163
Circle -5825686 true false 88 159 4
Circle -5825686 true false 89 163 4
Circle -5825686 true false 84 163 4
Polygon -6459832 true false 118 168 121 162 124 163 125 159 129 160 128 166 123 164 123 168
Polygon -6459832 true false 104 166 107 160 110 161 111 157 115 158 114 164 109 162 109 166
Polygon -6459832 true false 169 162 173 161 185 176 176 175
Polygon -6459832 true false 240 161 244 160 256 175 247 174
Polygon -6459832 true false 224 161 228 160 240 175 231 174
Polygon -6459832 true false 204 161 208 160 220 175 211 174
Polygon -6459832 true false 186 162 190 161 202 176 193 175
Rectangle -1 true false 170 161 177 165
Rectangle -1 true false 241 159 248 163
Rectangle -1 true false 222 160 229 164
Rectangle -1 true false 206 160 213 164
Rectangle -1 true false 187 160 194 164
Polygon -2674135 true false 47 212 47 229 67 231 67 208 49 209
Polygon -1 false false 52 209 49 211 64 212 66 210
Circle -7500403 true true 49 214 7
Circle -7500403 true true 52 222 7
Circle -7500403 true true 58 216 7
Polygon -2674135 true false 28 217 28 234 48 236 48 213 30 214
Polygon -1 false false 31 214 28 216 43 217 45 215
Circle -7500403 true true 39 220 7
Circle -7500403 true true 34 226 7
Circle -7500403 true true 29 219 7
Polygon -2674135 true false 67 211 67 228 87 230 87 207 69 208
Polygon -1 false false 71 208 68 210 83 211 85 209
Circle -7500403 true true 73 219 7
Circle -7500403 true true 76 213 7
Circle -7500403 true true 68 214 7
Polygon -2674135 true false 55 218 55 235 75 237 75 214 57 215
Polygon -1 false false 59 215 56 217 71 218 73 216
Circle -7500403 true true 61 227 7
Circle -7500403 true true 65 220 7
Circle -7500403 true true 57 220 7
Polygon -16777216 true false 85 211 85 228 105 230 105 207 87 208
Polygon -1 false false 89 208 86 210 101 211 103 209
Circle -6459832 true false 86 214 7
Circle -6459832 true false 92 220 7
Circle -6459832 true false 96 213 7
Polygon -16777216 false false 51 159 42 175 54 174 59 159
Polygon -16777216 false false 124 160 115 176 127 175 132 160
Polygon -16777216 false false 106 160 97 176 109 175 114 160
Polygon -16777216 false false 88 160 79 176 91 175 96 160
Polygon -16777216 false false 69 159 60 175 72 174 77 159
Polygon -16777216 true false 78 219 78 236 98 238 98 215 80 216
Polygon -1 false false 81 218 78 220 93 221 95 219
Circle -6459832 true false 80 223 7
Circle -6459832 true false 84 229 7
Circle -6459832 true false 90 223 7
Polygon -16777216 true false 108 211 108 228 128 230 128 207 110 208
Polygon -1 false false 112 208 111 212 126 211 126 208
Circle -6459832 true false 111 214 7
Circle -6459832 true false 115 222 7
Circle -6459832 true false 120 215 7
Polygon -16777216 true false 100 219 100 236 120 238 120 215 102 216
Polygon -1 false false 102 217 101 221 116 220 116 217
Circle -6459832 true false 107 230 7
Circle -6459832 true false 111 222 7
Circle -6459832 true false 102 224 7
Polygon -16777216 true false 129 213 129 230 149 232 149 209 131 210
Polygon -1 false false 131 210 130 214 145 213 145 210
Circle -6459832 true false 135 221 7
Circle -6459832 true false 140 215 7
Circle -6459832 true false 130 214 7
Polygon -16777216 true false 122 221 122 238 142 240 142 217 124 218
Polygon -1 false false 124 219 123 223 138 222 138 219
Circle -6459832 true false 128 232 7
Circle -6459832 true false 132 225 7
Circle -6459832 true false 123 224 7
Polygon -1184463 true false 241 218 278 231 284 239 274 239 237 226
Polygon -16777216 false false 277 230 275 238 284 237
Polygon -6459832 true false 250 222 246 227 254 229
Polygon -6459832 true false 263 225 259 230 267 232
Polygon -6459832 true false 256 225 252 230 260 232
Polygon -16777216 false false 240 218 236 225 274 238 277 231
Polygon -1184463 true false 219 217 256 230 262 238 252 238 215 225
Polygon -16777216 false false 218 217 214 224 252 237 255 230
Polygon -16777216 false false 255 229 253 237 262 236
Polygon -6459832 true false 242 227 238 232 246 234
Polygon -6459832 true false 235 223 231 228 239 230
Polygon -6459832 true false 229 221 225 226 233 228
Polygon -1184463 true false 197 217 234 230 240 238 230 238 193 225
Polygon -16777216 false false 196 217 192 224 230 237 233 230
Polygon -16777216 false false 233 229 231 237 240 236
Polygon -6459832 true false 221 226 217 231 225 233
Polygon -6459832 true false 213 223 209 228 217 230
Polygon -6459832 true false 206 221 202 226 210 228
Polygon -1184463 true false 175 218 212 231 218 239 208 239 171 226
Polygon -16777216 false false 175 218 171 225 209 238 212 231
Polygon -16777216 false false 212 232 210 240 219 239
Polygon -6459832 true false 199 226 195 231 203 233
Polygon -6459832 true false 191 224 187 229 195 231
Polygon -6459832 true false 183 221 179 226 187 228
Polygon -1184463 true false 155 219 192 232 198 240 188 240 151 227
Polygon -16777216 false false 154 219 150 226 188 239 191 232
Polygon -16777216 false false 191 232 189 240 198 239
Polygon -6459832 true false 165 222 161 227 169 229
Polygon -6459832 true false 182 228 178 233 186 235
Polygon -6459832 true false 174 226 170 231 178 233
Polygon -13345367 true false 34 255 35 276 47 277 52 273 52 251 37 251
Polygon -8630108 true false 38 252 35 254 50 254 50 251
Polygon -16777216 false false 35 256 49 255 49 274 36 273
Circle -1184463 true false 37 258 4
Circle -13791810 true false 39 267 4
Circle -2674135 true false 37 263 4
Circle -955883 true false 43 258 4
Circle -8630108 true false 42 261 4
Circle -13840069 true false 43 266 4
Polygon -13345367 true false 20 261 21 282 33 283 38 279 38 257 23 257
Polygon -16777216 false false 21 261 35 260 35 279 22 278
Polygon -8630108 true false 23 258 20 260 35 260 35 257
Circle -1184463 true false 23 262 4
Circle -955883 true false 30 262 4
Circle -2674135 true false 24 267 4
Circle -8630108 true false 30 268 4
Circle -13791810 true false 25 272 4
Circle -13840069 true false 30 272 4
Polygon -13345367 true false 54 255 55 276 67 277 72 273 72 251 57 251
Polygon -16777216 false false 55 256 69 255 69 274 56 273
Polygon -8630108 true false 57 252 54 254 69 254 69 251
Circle -1184463 true false 56 257 4
Circle -955883 true false 63 259 4
Circle -2674135 true false 57 261 4
Circle -8630108 true false 64 263 4
Circle -13791810 true false 59 267 4
Circle -13840069 true false 63 268 4
Polygon -13345367 true false 42 262 43 283 55 284 60 280 60 258 45 258
Polygon -16777216 false false 43 263 57 262 57 281 44 280
Polygon -8630108 true false 45 259 42 261 57 261 57 258
Circle -1184463 true false 44 264 4
Circle -955883 true false 50 265 4
Circle -2674135 true false 45 269 4
Circle -8630108 true false 52 272 4
Circle -13791810 true false 47 273 4
Circle -13840069 true false 52 277 4
Polygon -13345367 true false 74 254 75 275 87 276 92 272 92 250 77 250
Polygon -13345367 true false 96 253 97 274 109 275 114 271 114 249 99 249
Polygon -16777216 false false 96 254 110 253 110 272 97 271
Polygon -16777216 false false 74 255 88 254 88 273 75 272
Polygon -8630108 true false 100 250 97 252 112 252 112 249
Polygon -8630108 true false 77 252 74 254 89 254 89 251
Polygon -13345367 true false 136 253 137 274 149 275 154 271 154 249 139 249
Polygon -13345367 true false 116 253 117 274 129 275 134 271 134 249 119 249
Polygon -16777216 false false 137 253 151 252 151 271 138 270
Polygon -16777216 false false 116 254 130 253 130 272 117 271
Polygon -8630108 true false 140 250 137 252 152 252 152 249
Polygon -8630108 true false 120 251 117 253 132 253 132 250
Circle -1184463 true false 138 254 4
Circle -1184463 true false 118 256 4
Circle -1184463 true false 99 257 4
Circle -1184463 true false 76 257 4
Circle -955883 true false 145 253 4
Circle -955883 true false 124 256 4
Circle -955883 true false 105 256 4
Circle -955883 true false 81 258 4
Circle -2674135 true false 141 259 4
Circle -2674135 true false 119 260 4
Circle -2674135 true false 76 263 4
Circle -2674135 true false 98 261 4
Circle -8630108 true false 146 261 4
Circle -8630108 true false 125 258 4
Circle -8630108 true false 104 261 4
Circle -8630108 true false 83 262 4
Circle -13791810 true false 138 266 4
Circle -13791810 true false 119 265 4
Circle -13791810 true false 100 267 4
Circle -13791810 true false 77 269 4
Circle -13840069 true false 144 266 4
Circle -13840069 true false 124 266 4
Circle -13840069 true false 106 265 4
Circle -13840069 true false 83 267 4
Polygon -13345367 true false 127 261 128 282 140 283 145 279 145 257 130 257
Polygon -13345367 true false 104 264 105 285 117 286 122 282 122 260 107 260
Polygon -13345367 true false 85 261 86 282 98 283 103 279 103 257 88 257
Polygon -13345367 true false 64 261 65 282 77 283 82 279 82 257 67 257
Polygon -16777216 false false 126 262 140 261 140 280 127 279
Polygon -16777216 false false 104 265 118 264 118 283 105 282
Polygon -16777216 false false 86 263 100 262 100 281 87 280
Polygon -16777216 false false 64 263 78 262 78 281 65 280
Polygon -8630108 true false 129 258 126 260 141 260 141 257
Polygon -8630108 true false 108 261 105 263 120 263 120 260
Polygon -8630108 true false 89 258 86 260 101 260 101 257
Polygon -8630108 true false 68 259 65 261 80 261 80 258
Circle -1184463 true false 129 262 4
Circle -1184463 true false 106 266 4
Circle -1184463 true false 90 265 4
Circle -1184463 true false 65 264 4
Circle -955883 true false 134 263 4
Circle -955883 true false 111 267 4
Circle -955883 true false 94 263 4
Circle -955883 true false 71 264 4
Circle -2674135 true false 128 270 4
Circle -2674135 true false 106 271 4
Circle -2674135 true false 88 270 4
Circle -2674135 true false 66 270 4
Circle -8630108 true false 134 268 4
Circle -8630108 true false 112 272 4
Circle -8630108 true false 95 269 4
Circle -8630108 true false 72 269 4
Circle -13791810 true false 131 274 4
Circle -13791810 true false 106 275 4
Circle -13791810 true false 88 274 4
Circle -13791810 true false 68 274 4
Circle -13840069 true false 136 275 4
Circle -13840069 true false 111 278 4
Circle -13840069 true false 94 275 4
Circle -13840069 true false 73 275 4
Rectangle -16777216 true false 150 196 159 300
Polygon -10899396 true false 224 256 225 271 239 283 265 280 266 270 240 272
Polygon -955883 true false 224 258 244 258 266 268 267 272 241 274 227 262
Circle -7500403 true true 231 256 7
Circle -7500403 true true 231 256 7
Circle -7500403 true true 235 263 7
Circle -7500403 true true 245 268 7
Circle -7500403 true true 257 264 7
Circle -7500403 true true 249 260 7
Circle -7500403 true true 241 260 7
Polygon -2064490 true false 180 257 181 272 195 284 221 281 222 271 196 273
Polygon -13791810 true false 180 259 200 259 222 269 223 273 197 275 183 263
Circle -1 true false 197 256 7
Circle -1 true false 190 263 7
Circle -1 true false 211 266 7
Circle -1 true false 201 268 7
Circle -1 true false 204 262 7
Circle -1 true false 196 262 7
Circle -1 true false 185 258 7

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cleaning shelf
false
0
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 45 181 54 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 0 195 45 180 255 180 300 195
Rectangle -16777216 true false 0 195 300 200
Rectangle -1 true false 36 195 54 200
Rectangle -1 true false 93 195 111 200
Rectangle -1 true false 177 195 195 200
Polygon -6459832 true false 0 240 45 225 255 225 300 240
Polygon -6459832 true false 0 285 45 270 255 270 300 285
Rectangle -16777216 true false 0 285 300 290
Rectangle -16777216 true false 0 240 300 245
Rectangle -1 true false 36 240 54 245
Rectangle -1 true false 93 240 111 245
Rectangle -1 true false 222 240 240 245
Rectangle -1 true false 36 285 54 290
Rectangle -1 true false 93 285 111 290
Rectangle -1 true false 222 285 240 290
Rectangle -16777216 true false 0 196 9 300
Rectangle -16777216 true false 291 196 300 300
Rectangle -16777216 true false 150 196 159 300
Rectangle -1 true false 222 195 240 200
Rectangle -1 true false 177 240 195 245
Rectangle -1 true false 177 285 195 290
Polygon -1 true false 165 165 166 183 170 185 175 185 183 184 186 181 186 166 184 162 176 161 167 161
Polygon -1 false false 166 162 166 169 171 173 182 172 186 167 182 162 172 160
Polygon -6459832 true false 178 165 172 164 171 168 175 171 180 169
Polygon -1 true false 189 171 190 189 194 191 199 191 207 190 210 187 210 172 208 168 200 167 191 167
Polygon -1 true false 215 171 216 189 220 191 225 191 233 190 236 187 236 172 234 168 226 167 217 167
Polygon -1 true false 241 169 242 187 246 189 251 189 259 188 262 185 262 170 260 166 252 165 243 165
Polygon -1 false false 242 166 242 173 247 177 258 176 262 171 258 166 248 164
Polygon -1 false false 215 169 215 176 220 180 231 179 235 174 231 169 221 167
Polygon -1 false false 189 168 189 175 194 179 205 178 209 173 205 168 195 166
Polygon -6459832 true false 254 169 248 168 247 172 251 175 256 173
Polygon -6459832 true false 227 171 221 170 220 174 224 177 229 175
Polygon -6459832 true false 201 169 195 168 194 172 198 175 203 173
Polygon -1 true false 179 151 180 169 184 171 189 171 197 170 200 167 200 152 198 148 190 147 181 147
Polygon -1 false false 180 149 180 156 185 160 196 159 200 154 196 149 186 147
Polygon -1 true false 203 155 204 173 208 175 213 175 221 174 224 171 224 156 222 152 214 151 205 151
Polygon -1 true false 227 154 228 172 232 174 237 174 245 173 248 170 248 155 246 151 238 150 229 150
Polygon -1 false false 203 152 203 159 208 163 219 162 223 157 219 152 209 150
Polygon -1 false false 227 152 227 159 232 163 243 162 247 157 243 152 233 150
Polygon -6459832 true false 239 154 233 153 232 157 236 160 241 158
Polygon -6459832 true false 214 155 208 154 207 158 211 161 216 159
Polygon -6459832 true false 192 152 186 151 185 155 189 158 194 156
Polygon -1 true false 211 215 212 233 216 235 221 235 229 234 232 231 232 216 230 212 222 211 213 211
Polygon -1 true false 187 214 188 232 192 234 197 234 205 233 208 230 208 215 206 211 198 210 189 210
Polygon -1 true false 260 216 261 234 265 236 270 236 278 235 281 232 281 217 279 213 271 212 262 212
Polygon -1 true false 236 214 237 232 241 234 246 234 254 233 257 230 257 215 255 211 247 210 238 210
Polygon -1 false false 261 214 261 221 266 225 277 224 281 219 277 214 267 212
Polygon -1 false false 236 211 236 218 241 222 252 221 256 216 252 211 242 209
Polygon -1 false false 212 213 212 220 217 224 228 223 232 218 228 213 218 211
Polygon -1 false false 187 211 187 218 192 222 203 221 207 216 203 211 193 209
Polygon -6459832 true false 198 214 192 213 191 217 195 220 200 218
Polygon -6459832 true false 223 215 217 214 216 218 220 221 225 219
Polygon -6459832 true false 248 213 242 212 241 216 245 219 250 217
Polygon -6459832 true false 273 216 267 215 266 219 270 222 275 220
Polygon -1 true false 165 254 190 250 190 252 197 256 201 271 200 277 193 280 169 279 163 271 166 259
Polygon -1 true false 207 254 232 250 232 252 239 256 243 271 242 277 235 280 211 279 205 271 208 259
Polygon -5825686 true false 247 255 272 251 272 253 279 257 283 272 282 278 275 281 251 280 245 272 248 260
Circle -13345367 true false 213 260 8
Circle -13345367 true false 219 267 6
Circle -13345367 true false 210 269 8
Polygon -13840069 true false 183 266 179 268 175 267 177 261 170 260 173 257 179 256 181 254 185 254 186 259 191 257 193 260 189 263 192 267 188 269
Polygon -2674135 true false 172 270 172 276 175 271 177 275 179 274 176 267
Polygon -2674135 true false 180 270 182 276 184 276 184 272 187 275 186 270 185 268
Polygon -2674135 true false 190 271 191 275 194 276 194 271
Polygon -2674135 true false 171 263 181 259 181 256 180 256 177 257 170 257
Circle -1 true false 180 261 4
Polygon -11221820 true false 210 263 210 255 224 255 232 255 236 261 230 257 216 259
Polygon -11221820 true false 221 276 232 275 238 267 239 273 235 279
Polygon -2674135 true false 217 264 218 273 224 271 224 267 220 268 220 265 223 264 222 260 214 262 214 262
Polygon -2674135 true false 225 261 227 271 230 271 230 262
Polygon -2674135 true false 232 263 232 267 237 271 240 269 239 264
Circle -13840069 true false 223 253 8
Circle -2674135 true false 253 256 23
Polygon -1 true false 253 269 273 264 274 270 254 274
Polygon -13791810 true false 255 265 259 276 261 275 265 264 262 264 260 272
Polygon -14835848 true false 128 206 125 212 124 219 123 228 123 232 129 234 135 234 136 230 136 219 135 219 134 219 137 216 137 211 134 207
Polygon -1184463 true false 133 230 125 230 127 221 127 216 133 220 133 223
Polygon -2674135 true false 129 204 129 208 135 208 135 205
Circle -14835848 true false 130 200 4
Polygon -14835848 true false 145 208 142 214 141 221 140 230 140 234 146 236 152 236 153 232 153 221 152 221 151 221 154 218 154 213 151 209
Polygon -1184463 true false 149 232 141 232 143 223 143 218 149 222 149 225
Polygon -2674135 true false 146 206 146 210 152 210 152 207
Circle -14835848 true false 148 203 4
Polygon -14835848 true false 111 208 108 214 107 221 106 230 106 234 112 236 118 236 119 232 119 221 118 221 117 221 120 218 120 213 117 209
Polygon -1184463 true false 116 233 108 233 110 224 110 219 116 223 116 226
Polygon -2674135 true false 111 208 111 212 117 212 117 209
Circle -14835848 true false 112 204 4
Polygon -1 true false 93 252 91 256 89 262 88 267 90 275 94 280 106 282 111 273 113 264 111 257 107 253
Polygon -6459832 true false 105 259 102 261 106 268 108 267 109 263
Polygon -10899396 true false 92 253 97 247 105 248 107 253
Polygon -1 true false 124 252 122 256 120 262 119 267 121 275 125 280 137 282 142 273 144 264 142 257 138 253
Polygon -13345367 true false 123 253 128 247 136 248 138 253
Polygon -6459832 true false 135 258 132 260 136 267 138 266 139 262
Polygon -5825686 true false 124 257 122 266 124 277 136 278 139 272 133 269 131 263 129 257
Circle -1 true false 123 266 8
Polygon -16777216 true false 124 274 131 273 131 269 138 271 136 277
Circle -11221820 true false 121 263 6
Polygon -13840069 true false 96 274 92 276 88 275 90 269 88 268 91 264 92 264 94 262 98 262 99 267 104 265 106 268 102 271 105 275 101 277
Polygon -2674135 true false 92 272 92 278 95 273 97 277 99 276 96 269
Polygon -2674135 true false 97 269 99 275 101 275 101 271 104 274 103 269 102 267
Polygon -2674135 true false 103 268 104 272 107 273 107 268
Polygon -1184463 true false 64 252 62 256 60 262 59 267 61 275 65 280 77 282 82 273 84 264 82 257 78 253
Polygon -1 true false 64 253 69 247 77 248 79 253
Polygon -1 true false 70 270 68 270 71 273 70 276 75 274 78 274 76 272 78 270 73 273
Polygon -1 true false 70 270 68 270 71 273 70 276 75 274 78 274 76 272 78 270 73 273
Polygon -1 true false 73 264 71 264 74 267 73 270 78 268 81 268 79 266 81 264 76 267
Polygon -1 true false 63 268 61 268 64 271 63 274 68 272 71 272 69 270 71 268 66 271
Circle -2064490 true false 69 272 4
Circle -2064490 true false 73 265 4
Circle -2064490 true false 62 267 4
Polygon -14835848 true false 63 264 64 260 67 264 71 262 71 262 74 263 77 262 76 266 72 264 67 265
Polygon -13345367 true false 32 252 30 256 28 262 27 267 29 275 33 280 45 282 50 273 52 264 50 257 46 253
Polygon -6459832 true false 43 258 40 260 44 267 46 266 47 262
Polygon -6459832 true false 75 259 72 261 76 268 78 267 79 263
Polygon -1 true false 32 253 37 247 45 248 47 253
Polygon -1 true false 33 257 31 266 33 277 45 278 48 272 42 269 40 263 38 257
Polygon -2674135 true false 38 276 36 273 38 270 40 272 42 272 43 275
Polygon -2674135 true false 31 265 36 265 32 269 36 269
Polygon -2674135 true false 36 265 42 265 42 268 40 265 37 265 37 267
Polygon -2674135 true false 34 266 38 263 39 267 42 267 42 271 40 268 36 268
Polygon -1 true false 32 233 32 214 36 204 40 204 44 215 44 232 40 235 36 235
Polygon -1 true false 62 232 62 213 66 203 70 203 74 214 74 231 70 234 66 234
Polygon -1 true false 47 232 47 213 51 203 55 203 59 214 59 231 55 234 51 234
Polygon -1184463 true false 31 218 44 219 44 226 33 226
Polygon -1184463 true false 61 217 74 218 74 225 63 225
Polygon -1184463 true false 46 218 59 219 59 226 48 226
Circle -13345367 true false 34 219 7
Circle -13345367 true false 64 218 7
Circle -13345367 true false 49 218 7
Polygon -13791810 true false 91 234 91 215 95 205 99 205 103 216 103 233 99 236 95 236
Polygon -13791810 true false 77 234 77 215 81 205 85 205 89 216 89 233 85 236 81 236
Polygon -1184463 true false 92 221 102 221 102 228 91 228
Polygon -1184463 true false 77 218 88 219 88 226 77 226
Circle -13345367 true false 92 221 7
Circle -13345367 true false 78 219 7
Polygon -1 true false 80 203 80 207 85 206 85 204
Polygon -1 true false 94 203 94 207 99 206 99 204
Polygon -1 true false 74 150 78 150 84 166 84 169 86 170 90 179 85 187 86 190 70 190 71 185 69 182 69 177 72 168 74 168 76 160 72 159 72 155
Polygon -1 true false 74 151 70 150 66 155 67 148 64 146 65 143 81 143 83 148 78 149 77 151
Polygon -1 true false 74 150 78 150 84 166 84 169 86 170 90 179 85 187 86 190 70 190 71 185 69 182 69 177 72 168 74 168 76 160 72 159 72 155
Polygon -1 true false 45 150 49 150 55 166 55 169 57 170 61 179 56 187 57 190 41 190 42 185 40 182 40 177 43 168 45 168 47 160 43 159 43 155
Polygon -1 true false 45 152 41 151 37 156 38 149 35 147 36 144 52 144 54 149 49 150 48 152
Polygon -5825686 true false 44 188 44 186 42 181 42 178 43 172 45 170 53 170 55 171 59 179 55 183 54 185 54 187
Polygon -5825686 true false 73 188 73 186 71 181 71 178 72 172 74 170 82 170 84 171 88 179 84 183 83 185 83 187
Circle -14835848 true false 44 172 10
Circle -14835848 true false 74 171 10
Polygon -14835848 true false 41 144 42 147 46 147 46 151 50 150 53 148 52 143
Polygon -14835848 true false 71 143 72 146 76 146 76 150 80 149 83 147 82 142
Polygon -1 true false 47 175 48 177 53 174 52 172
Polygon -1 true false 76 178 77 180 82 177 81 175
Polygon -1 true false 76 174 77 176 82 173 81 171
Polygon -1 true false 46 180 47 182 52 179 51 177
Polygon -1 true false 129 163 129 184 137 184 138 163
Polygon -1 true false 118 166 118 187 126 187 127 166
Polygon -1 true false 109 163 109 184 117 184 118 163
Polygon -1 true false 98 171 98 192 106 192 107 171
Polygon -8630108 true false 98 171 99 166 99 162 104 161 106 165 106 171
Polygon -955883 true false 118 169 119 164 119 160 124 159 126 163 126 169
Polygon -2064490 true false 109 165 111 160 111 156 116 155 118 159 118 165
Polygon -11221820 true false 129 163 130 158 130 154 135 153 137 157 137 163
Polygon -11221820 true false 129 183 131 181 135 180 136 182
Polygon -955883 true false 119 186 121 184 125 183 126 185
Polygon -8630108 true false 99 191 101 189 105 188 106 190
Polygon -2064490 true false 109 183 111 181 115 180 116 182
Circle -10899396 true false 98 171 7
Circle -10899396 true false 130 163 7
Circle -10899396 true false 120 169 7
Circle -10899396 true false 110 165 7
Polygon -1184463 true false 143 180 137 187 138 190 163 190 164 189 158 182
Polygon -11221820 true false 143 180 137 187 138 190 163 190 164 189 158 182
Polygon -14835848 true false 143 175 137 182 138 185 163 185 164 184 158 177
Polygon -1184463 true false 143 169 137 176 138 179 163 179 164 178 158 171
Rectangle -1184463 true false 166 228 181 235
Rectangle -14835848 true false 166 226 180 229
Rectangle -1184463 true false 166 208 181 215
Rectangle -2674135 true false 166 218 181 225
Rectangle -14835848 true false 166 205 180 208
Rectangle -14835848 true false 167 215 181 218

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dairy fridge
false
12
Polygon -16777216 true false 4 18 47 3 46 208 3 226
Rectangle -16777216 true false 47 46 54 210
Polygon -16777216 true false 298 269 249 285 249 300 299 283 294 270
Polygon -14835848 true false 255 195 300 165 45 90 0 120
Polygon -16777216 true false 295 185 251 199 251 204 295 190 295 186 295 186
Polygon -14835848 true false 255 240 300 210 45 135 0 165
Polygon -14835848 true false 255 285 300 255 45 180 0 210
Polygon -16777216 true false 290 272 246 286 246 291 290 277 290 273 290 273
Polygon -16777216 true false 295 231 251 245 251 250 295 236 295 232 295 232
Rectangle -16777216 true false 0 30 9 225
Polygon -14835848 true false 255 150 300 120 45 45 0 75
Polygon -16777216 true false 294 139 250 153 250 158 294 144 294 140 294 140
Line -16777216 false 45 45 300 120
Polygon -16777216 true false 2 17 5 50 260 125 261 93
Polygon -16777216 true false 2 78 0 74 252 148 254 152
Polygon -16777216 true false 0 210 0 225 255 300 255 285
Polygon -16777216 true false 2 123 0 119 252 193 254 197
Polygon -16777216 true false 2 168 0 164 252 238 254 242
Polygon -16777216 true false 2 213 0 209 252 283 254 287
Rectangle -16777216 true false 255 150 255 300
Rectangle -16777216 true false 251 90 258 284
Polygon -16777216 true false 2 33 0 29 252 103 254 107
Polygon -16777216 true false 296 77 252 91 252 96 296 82 296 78 296 78
Polygon -16777216 true false 256 91 299 76 298 281 255 299
Polygon -7500403 true false 1 16 46 2 299 75 251 90
Line -6459832 false 252 88 252 297
Polygon -1 true false 42 180 42 187 59 188 59 186
Polygon -1 true false 42 180 42 187 59 188 59 186
Polygon -5825686 true true 161 215 161 222 178 223 178 221
Polygon -1 true false 136 208 136 215 153 216 153 214
Polygon -1 true false 111 200 111 207 128 208 128 206
Polygon -1 true false 87 193 87 200 104 201 104 199
Polygon -1 true false 64 186 64 193 81 194 81 192
Polygon -5825686 true true 184 222 184 229 201 230 201 228
Polygon -5825686 true true 232 236 232 243 249 244 249 242
Polygon -5825686 true true 208 229 208 236 225 237 225 235
Polygon -1 true false 21 181 27 173 43 179 46 191 45 204 37 211 23 207
Polygon -10899396 true false 21 184 38 188 45 187 46 198 37 203 22 197
Polygon -5825686 true true 168 226 174 218 190 224 193 236 192 249 184 256 170 252
Polygon -5825686 true true 136 217 142 209 158 215 161 227 160 240 152 247 138 243
Polygon -1 true false 105 206 111 198 127 204 130 216 129 229 121 236 107 232
Polygon -1 true false 78 199 84 191 100 197 103 209 102 222 94 229 80 225
Polygon -1 true false 49 190 55 182 71 188 74 200 73 213 65 220 51 216
Polygon -5825686 true true 222 241 228 233 244 239 247 251 246 264 238 271 224 267
Polygon -5825686 true true 196 234 202 226 218 232 221 244 220 257 212 264 198 260
Polygon -10899396 true false 50 193 67 197 74 196 75 207 66 212 51 206
Polygon -10899396 true false 78 203 95 207 102 206 103 217 94 222 79 216
Polygon -10899396 true false 105 210 122 214 129 213 130 224 121 229 106 223
Polygon -6459832 true false 137 221 154 225 161 224 162 235 153 240 138 234
Polygon -6459832 true false 167 229 184 233 191 232 192 243 183 248 168 242
Polygon -6459832 true false 197 239 214 243 221 242 222 253 213 258 198 252
Polygon -6459832 true false 222 246 239 250 246 249 247 260 238 265 223 259
Polygon -1 true false 25 189 27 196 32 197 34 192
Polygon -1 true false 225 250 227 257 232 258 234 253
Polygon -1 true false 201 243 203 250 208 251 210 246
Polygon -1 true false 172 233 174 240 179 241 181 236
Polygon -1 true false 141 225 143 232 148 233 150 228
Polygon -1 true false 109 214 111 221 116 222 118 217
Polygon -1 true false 83 207 85 214 90 215 92 210
Polygon -1 true false 55 198 57 205 62 206 64 201
Circle -16777216 true false 58 200 4
Circle -16777216 true false 29 191 4
Circle -16777216 true false 229 252 4
Circle -16777216 true false 203 244 4
Circle -16777216 true false 176 234 4
Circle -16777216 true false 145 226 4
Circle -16777216 true false 113 216 4
Circle -16777216 true false 85 208 4
Polygon -1 true false 27 137 33 129 49 135 52 147 51 160 43 167 29 163
Polygon -1 true false 108 163 114 155 130 161 133 173 132 186 124 193 110 189
Polygon -1 true false 80 154 86 146 102 152 105 164 104 177 96 184 82 180
Polygon -1 true false 54 147 60 139 76 145 79 157 78 170 70 177 56 173
Polygon -6459832 true false 138 173 144 165 160 171 163 183 162 196 154 203 140 199
Polygon -6459832 true false 170 182 176 174 192 180 195 192 194 205 186 212 172 208
Polygon -2064490 true false 224 198 230 190 246 196 249 208 248 221 240 228 226 224
Polygon -2064490 true false 197 190 203 182 219 188 222 200 221 213 213 220 199 216
Polygon -2674135 true false 225 202 242 206 249 205 250 216 241 221 226 215
Polygon -2674135 true false 197 193 214 197 221 196 222 207 213 212 198 206
Polygon -16777216 true false 169 185 186 189 193 188 194 199 185 204 170 198
Polygon -16777216 true false 138 178 155 182 162 181 163 192 154 197 139 191
Polygon -11221820 true false 27 141 44 145 51 144 52 155 43 160 28 154
Polygon -11221820 true false 107 166 124 170 131 169 132 180 123 185 108 179
Polygon -11221820 true false 81 159 98 163 105 162 106 173 97 178 82 172
Polygon -11221820 true false 54 152 71 156 78 155 79 166 70 171 55 165
Polygon -1 true false 32 145 34 152 39 153 41 148
Polygon -1 true false 228 206 230 213 235 214 237 209
Polygon -1 true false 201 197 203 204 208 205 210 200
Polygon -1 true false 174 189 176 196 181 197 183 192
Polygon -1 true false 142 183 144 190 149 191 151 186
Polygon -1 true false 111 170 113 177 118 178 120 173
Polygon -1 true false 85 164 87 171 92 172 94 167
Polygon -1 true false 59 156 61 163 66 164 68 159
Circle -16777216 true false 35 147 4
Circle -16777216 true false 230 208 4
Circle -16777216 true false 204 199 4
Circle -16777216 true false 177 191 4
Circle -16777216 true false 144 185 4
Circle -16777216 true false 114 172 4
Circle -16777216 true false 87 166 4
Circle -16777216 true false 64 159 4
Polygon -1184463 true false 35 101 35 109 59 107 59 99 46 93
Polygon -1184463 true false 65 124 65 132 89 130 89 122 76 116
Polygon -1184463 true false 35 116 35 124 59 122 59 114 46 108
Polygon -1184463 true false 62 108 62 116 86 114 86 106 73 100
Line -955883 false 35 101 59 100
Line -955883 false 65 125 89 124
Line -955883 false 61 109 85 108
Line -955883 false 34 116 58 115
Polygon -955883 true false 114 121 96 132 95 140 112 143 127 134 129 126
Line -1184463 false 96 132 113 135
Line -1184463 false 111 142 113 135
Line -1184463 false 113 136 127 126
Polygon -955883 true false 146 122 128 133 127 141 144 144 159 135 161 127
Polygon -955883 true false 164 135 146 146 145 154 162 157 177 148 179 140
Line -1184463 false 146 146 163 149
Line -1184463 false 127 134 144 137
Line -1184463 false 162 157 164 150
Line -1184463 false 142 143 144 136
Line -1184463 false 163 150 177 140
Line -1184463 false 144 137 158 127
Polygon -1 true false 40 113 43 111 51 116 52 122 44 122 44 117
Polygon -1 true false 69 120 72 118 80 123 81 129 73 129 73 124
Polygon -1 true false 66 105 69 103 77 108 78 114 70 114 70 109
Polygon -1 true false 40 98 43 96 51 101 52 107 44 107 44 102
Polygon -1 true false 103 128 121 132 118 138 123 135 125 129 107 124
Polygon -1 true false 152 143 170 147 167 153 172 150 174 144 156 139
Polygon -1 true false 134 129 152 133 149 139 154 136 156 130 138 125
Polygon -1 true false 216 163 209 170 211 178 216 182 225 182 229 178 231 170 226 163
Polygon -1 true false 234 149 227 156 229 164 234 168 243 168 247 164 249 156 244 149
Polygon -1 true false 209 143 202 150 204 158 209 162 218 162 222 158 224 150 219 143
Polygon -1 true false 183 150 176 157 178 165 183 169 192 169 196 165 198 157 193 150
Polygon -1184463 true false 176 157 184 163 191 162 197 159 193 151 183 151 177 156 177 156
Polygon -1184463 true false 227 156 235 162 242 161 248 158 244 150 234 150 228 155 228 155
Polygon -1184463 true false 208 170 216 176 223 175 229 172 225 164 215 164 209 169 209 169
Polygon -1184463 true false 202 149 210 155 217 154 223 151 219 143 209 143 203 148 203 148
Polygon -2674135 true false 90 75 75 84 78 93 85 95 85 88 89 96 94 98 99 94 98 86 104 91 111 87 110 82
Polygon -1 true false 84 85 78 84 84 81 88 83
Polygon -1 true false 100 83 94 82 100 79 104 81
Polygon -1 true false 91 80 85 79 91 76 95 78
Polygon -1 true false 92 87 86 86 92 83 96 85
Polygon -2674135 true false 57 65 42 74 45 83 52 85 52 78 56 86 61 88 66 84 65 76 71 81 78 77 77 72
Polygon -2674135 true false 28 56 13 65 16 74 23 76 23 69 27 77 32 79 37 75 36 67 42 72 49 68 48 63
Polygon -1 true false 59 77 53 76 59 73 63 75
Polygon -1 true false 65 73 59 72 65 69 69 71
Polygon -1 true false 50 75 44 74 50 71 54 73
Polygon -1 true false 58 70 52 69 58 66 62 68
Polygon -1 true false 30 69 24 68 30 65 34 67
Polygon -1 true false 36 64 30 63 36 60 40 62
Polygon -1 true false 21 67 15 66 21 63 25 65
Polygon -1 true false 28 61 22 60 28 57 32 59
Polygon -1 true false 112 89 112 89 117 93 124 97 130 97 133 95 130 108 122 108 113 104
Polygon -2064490 true false 114 89 121 94 124 95 132 95 132 92 127 90 121 89
Polygon -1 true false 215 117 215 117 220 121 227 125 233 125 236 123 233 136 225 136 216 132
Polygon -1 true false 187 110 187 110 192 114 199 118 205 118 208 116 205 129 197 129 188 125
Polygon -1 true false 163 102 163 102 168 106 175 110 181 110 184 108 181 121 173 121 164 117
Polygon -1 true false 138 95 138 95 143 99 150 103 156 103 159 101 156 114 148 114 139 110
Polygon -1 true false 217 117 224 122 227 123 235 123 235 120 230 118 224 117
Polygon -1 true false 188 109 195 114 198 115 206 115 206 112 201 110 195 109
Polygon -2064490 true false 166 103 173 108 176 109 184 109 184 106 179 104 173 103
Polygon -2064490 true false 139 95 146 100 149 101 157 101 157 98 152 96 146 95
Circle -1 false false 65 150 11
Polygon -1 false false 9 53 8 210 80 231 84 74
Polygon -1 false false 87 74 84 230 164 256 166 97
Polygon -1 false false 171 100 168 256 248 282 250 123
Circle -1 false false 150 179 11
Circle -1 false false 235 200 11
Line -1 false 63 81 22 205
Line -1 false 41 111 23 170
Line -1 false 60 120 47 156
Line -1 false 142 95 101 219
Line -1 false 118 126 100 185
Line -1 false 133 152 120 188
Line -1 false 225 131 184 255
Line -1 false 207 151 189 210
Line -1 false 217 187 204 223

dot
false
0
Circle -7500403 true true 90 90 120

egg shelf
false
0
Rectangle -16777216 true false 47 46 54 210
Polygon -16777216 true false 294 270 249 285 249 300 294 285 294 270
Rectangle -16777216 true false 286 117 295 285
Polygon -6459832 true false 257 151 302 121 47 46 2 76
Polygon -16777216 true false 295 185 251 199 251 204 295 190 295 186 295 186
Polygon -6459832 true false 255 240 300 210 45 135 0 165
Polygon -6459832 true false 260 285 305 255 50 180 5 210
Polygon -16777216 true false 290 272 246 286 246 291 290 277 290 273 290 273
Polygon -16777216 true false 295 231 251 245 251 250 295 236 295 232 295 232
Rectangle -16777216 true false 1 75 9 225
Polygon -6459832 true false 257 194 302 164 47 89 2 119
Polygon -16777216 true false 294 139 250 153 250 158 294 144 294 140 294 140
Line -16777216 false 45 45 300 120
Polygon -6459832 true false 45 30 45 45 300 120 300 105
Polygon -16777216 true false 45 30 44 23 300 99 300 105
Polygon -16777216 true false 2 78 0 74 252 148 254 152
Polygon -16777216 true false 0 210 0 225 255 300 255 285
Polygon -16777216 true false 2 123 0 119 252 193 254 197
Polygon -16777216 true false 2 168 0 164 252 238 254 242
Polygon -16777216 true false 2 213 0 209 252 283 254 287
Rectangle -16777216 true false 255 150 255 300
Rectangle -16777216 true false 249 147 258 284
Polygon -7500403 true true 26 67 52 79 79 58 77 52 56 42 29 62
Circle -1 true false 51 45 10
Circle -1 true false 63 51 10
Circle -1 true false 53 58 10
Circle -1 true false 45 65 10
Circle -1 true false 32 59 10
Circle -1 true false 41 52 10
Polygon -7500403 true true 27 69 29 76 54 86 79 67 78 61 53 82
Polygon -7500403 true true 75 80 101 92 128 71 126 65 105 55 78 75
Polygon -7500403 true true 129 94 131 101 156 111 181 92 180 86 155 107
Polygon -7500403 true true 221 120 247 132 274 111 272 105 251 95 224 115
Polygon -7500403 true true 174 106 200 118 227 97 225 91 204 81 177 101
Polygon -7500403 true true 128 93 154 105 181 84 179 78 158 68 131 88
Polygon -7500403 true true 191 166 217 178 244 157 242 151 221 141 194 161
Polygon -7500403 true true 143 153 169 165 196 144 194 138 173 128 146 148
Polygon -7500403 true true 105 141 131 153 158 132 156 126 135 116 108 136
Polygon -7500403 true true 65 129 91 141 118 120 116 114 95 104 68 124
Polygon -7500403 true true 21 116 47 128 74 107 72 101 51 91 24 111
Polygon -7500403 true true 181 211 207 223 234 202 232 196 211 186 184 206
Polygon -7500403 true true 126 194 152 206 179 185 177 179 156 169 129 189
Polygon -7500403 true true 75 179 101 191 128 170 126 164 105 154 78 174
Polygon -7500403 true true 39 168 65 180 92 159 90 153 69 143 42 163
Polygon -7500403 true true 181 211 207 223 234 202 232 196 211 186 184 206
Polygon -7500403 true true 118 232 144 244 165 227 163 219 143 211 121 227
Polygon -7500403 true true 190 251 216 263 237 246 235 238 215 230 193 246
Polygon -7500403 true true 156 243 182 255 203 238 201 230 181 222 159 238
Polygon -7500403 true true 83 219 109 231 130 214 128 206 108 198 86 214
Polygon -7500403 true true 28 203 54 215 75 198 73 190 53 182 31 198
Circle -1 true false 100 57 10
Circle -1 true false 93 80 10
Circle -1 true false 82 73 10
Circle -1 true false 103 72 10
Circle -1 true false 91 65 10
Circle -1 true false 111 63 10
Circle -1 true false 154 71 10
Polygon -7500403 true true 76 83 78 90 103 100 128 81 127 75 102 96
Polygon -7500403 true true 174 108 176 115 201 125 226 106 225 100 200 121
Polygon -7500403 true true 221 122 223 129 248 139 273 120 272 114 247 135
Polygon -7500403 true true 221 122 223 129 248 139 273 120 272 114 247 135
Polygon -7500403 true true 21 118 23 125 48 135 73 116 72 110 47 131
Polygon -7500403 true true 105 142 107 149 132 159 157 140 156 134 131 155
Polygon -7500403 true true 65 131 67 138 92 148 117 129 116 123 91 144
Polygon -7500403 true true 191 169 193 176 218 186 243 167 242 161 217 182
Polygon -7500403 true true 143 155 145 162 170 172 195 153 194 147 169 168
Polygon -7500403 true true 75 181 77 188 102 198 127 179 126 173 101 194
Polygon -7500403 true true 39 169 41 176 66 186 91 167 90 161 65 182
Polygon -7500403 true true 182 212 184 219 209 229 234 210 233 204 208 225
Polygon -7500403 true true 126 195 128 202 153 212 178 193 177 187 152 208
Polygon -7500403 true true 28 205 30 212 55 222 80 203 79 197 54 218
Polygon -7500403 true true 82 220 84 227 109 237 130 221 129 214 108 233
Polygon -7500403 true true 190 252 192 259 217 269 238 253 237 246 216 265
Polygon -7500403 true true 156 244 158 251 183 261 204 245 203 238 182 257
Polygon -7500403 true true 118 233 120 240 145 250 166 234 165 227 144 246
Circle -1 true false 200 81 10
Circle -1 true false 146 93 10
Circle -1 true false 135 86 10
Circle -1 true false 144 79 10
Circle -1 true false 156 85 10
Circle -1 true false 165 77 10
Circle -1 true false 246 98 10
Circle -1 true false 192 108 10
Circle -1 true false 179 102 10
Circle -1 true false 201 99 10
Circle -1 true false 188 92 10
Circle -1 true false 211 89 10
Circle -1 true false 47 94 10
Circle -1 true false 237 121 10
Circle -1 true false 224 114 10
Circle -1 true false 234 106 10
Circle -1 true false 257 105 10
Circle -1 true false 246 113 10
Circle -1 true false 90 107 10
Circle -1 true false 58 99 10
Circle -1 true false 49 107 10
Circle -1 true false 40 116 10
Circle -1 true false 28 109 10
Circle -1 true false 38 101 10
Circle -1 true false 130 120 10
Circle -1 true false 84 128 10
Circle -1 true false 93 120 10
Circle -1 true false 102 112 10
Circle -1 true false 70 122 10
Circle -1 true false 80 115 10
Circle -1 true false 167 132 10
Circle -1 true false 123 143 10
Circle -1 true false 110 136 10
Circle -1 true false 131 133 10
Circle -1 true false 120 128 10
Circle -1 true false 142 125 10
Circle -1 true false 216 146 10
Circle -1 true false 161 153 10
Circle -1 true false 170 145 10
Circle -1 true false 179 137 10
Circle -1 true false 149 147 10
Circle -1 true false 158 139 10
Circle -1 true false 64 146 10
Circle -1 true false 207 169 10
Circle -1 true false 195 163 10
Circle -1 true false 216 161 10
Circle -1 true false 205 154 10
Circle -1 true false 228 153 10
Circle -1 true false 100 158 10
Circle -1 true false 57 171 10
Circle -1 true false 44 163 10
Circle -1 true false 64 162 10
Circle -1 true false 54 155 10
Circle -1 true false 76 154 10
Circle -1 true false 151 173 10
Circle -1 true false 92 182 10
Circle -1 true false 81 176 10
Circle -1 true false 89 167 10
Circle -1 true false 102 172 10
Circle -1 true false 112 164 10
Circle -1 true false 206 188 10
Circle -1 true false 144 194 10
Circle -1 true false 131 190 10
Circle -1 true false 155 187 10
Circle -1 true false 141 181 10
Circle -1 true false 164 177 10
Circle -1 true false 211 231 10
Circle -1 true false 200 210 10
Circle -1 true false 187 205 10
Circle -1 true false 211 202 10
Circle -1 true false 197 196 10
Circle -1 true false 219 194 10
Circle -1 true false 195 250 10
Circle -1 true false 175 223 10
Circle -1 true false 216 246 10
Circle -1 true false 203 241 10
Circle -1 true false 224 236 10
Circle -1 true false 173 244 10
Circle -1 true false 161 241 10
Circle -1 true false 182 236 10
Circle -1 true false 168 232 10
Circle -1 true false 188 227 10
Circle -1 true false 208 255 10
Circle -1 true false 138 213 10
Circle -1 true false 104 201 10
Circle -1 true false 123 229 10
Circle -1 true false 136 235 10
Circle -1 true false 132 221 10
Circle -1 true false 145 228 10
Circle -1 true false 151 219 10
Circle -1 true false 50 185 10
Circle -1 true false 97 222 10
Circle -1 true false 86 216 10
Circle -1 true false 108 214 10
Circle -1 true false 94 207 10
Circle -1 true false 117 206 10
Circle -1 true false 50 185 10
Circle -1 true false 42 208 10
Circle -1 true false 32 200 10
Circle -1 true false 52 200 10
Circle -1 true false 40 191 10
Circle -1 true false 61 191 10

empty queue shelf
false
0
Rectangle -6459832 true false 114 172 189 278
Rectangle -7500403 true true 104 278 195 287
Rectangle -7500403 true true 104 238 195 247
Rectangle -7500403 true true 105 201 196 210
Polygon -6459832 true false 105 120 195 120 195 165 105 165
Rectangle -7500403 true true 104 165 195 174
Rectangle -16777216 true false 104 165 114 300
Rectangle -16777216 true false 186 165 196 300
Line -16777216 false 105 165 105 120
Line -16777216 false 105 120 195 120
Line -16777216 false 195 120 195 165
Rectangle -2674135 true false 111 126 147 135
Rectangle -2674135 true false 153 126 189 135
Circle -13840069 true false 118 176 18
Circle -13840069 true false 163 177 18
Circle -13840069 true false 140 178 18
Polygon -2064490 true false 114 143 117 145 113 156 147 156 141 144 141 141
Polygon -2064490 true false 155 144 158 146 154 157 188 157 182 145 182 142
Rectangle -13345367 true false 120 213 141 222
Rectangle -13345367 true false 153 225 174 234
Rectangle -13345367 true false 120 227 141 236
Rectangle -13345367 true false 153 213 174 222
Polygon -955883 true false 121 253 145 261 147 270 139 275 124 267 117 260
Polygon -955883 true false 154 250 178 258 180 267 172 272 157 264 150 257

empty queue shelf 1
false
0
Rectangle -6459832 true false 114 172 189 278
Rectangle -7500403 true true 104 278 195 287
Rectangle -16777216 true false 104 165 114 300
Rectangle -16777216 true false 186 165 196 300

empty queue shelf 2
false
0
Rectangle -6459832 true false 114 172 189 278
Rectangle -7500403 true true 104 278 195 287
Rectangle -16777216 true false 104 165 114 300
Rectangle -16777216 true false 186 165 196 300
Rectangle -955883 true false 120 180 180 195
Rectangle -11221820 true false 121 201 178 213
Line -13840069 false 124 224 180 222
Line -13840069 false 123 233 181 232
Line -8630108 false 125 244 182 243
Polygon -5825686 true false 125 254 180 253 179 264 163 259 124 257
Circle -1184463 true false 125 260 13
Circle -1184463 true false 148 262 13

empty queue shelf 3
false
0
Rectangle -6459832 true false 114 172 189 278
Rectangle -7500403 true true 104 278 195 287
Rectangle -16777216 true false 104 165 114 300
Rectangle -16777216 true false 186 165 196 300
Rectangle -13345367 true false 120 180 180 195
Rectangle -13840069 true false 121 201 178 213
Line -955883 false 124 224 180 222
Line -955883 false 123 233 181 232
Line -1184463 false 125 244 182 243
Polygon -11221820 true false 125 254 180 253 179 264 163 259 124 257
Circle -2674135 true false 125 260 13
Circle -2674135 true false 148 262 13

empty queue shelf 4
false
0
Rectangle -16777216 true false 59 15 69 150
Polygon -6459832 true false 62 135 135 135 210 285 122 279
Polygon -6459832 true false 61 90 136 90 211 240 121 240
Polygon -6459832 true false 60 45 135 45 210 210 120 195
Rectangle -7500403 true true 119 278 210 287
Rectangle -7500403 true true 119 238 210 247
Rectangle -7500403 true true 120 201 211 210
Polygon -6459832 true false 64 17 135 17 210 167 122 163
Rectangle -7500403 true true 119 165 210 174
Rectangle -16777216 true false 118 164 128 299
Rectangle -16777216 true false 201 165 211 300
Polygon -16777216 true false 62 19 121 169 126 169 66 17
Polygon -2064490 true false 132 76
Line -16777216 false 60 45 120 195
Line -16777216 false 60 90 120 240
Line -16777216 false 61 134 122 279
Line -16777216 false 135 15 210 165
Line -16777216 false 64 15 135 15
Polygon -16777216 true false 59 50 118 200 123 200 63 48
Polygon -16777216 true false 58 92 117 242 122 242 62 90
Polygon -16777216 true false 60 132 119 282 124 282 64 130
Line -16777216 false 193 174 202 192
Line -16777216 false 195 210 202 223
Line -16777216 false 191 248 202 269

empty queue shelf 5
false
0
Rectangle -6459832 true false 114 172 189 278
Rectangle -7500403 true true 104 278 195 287
Rectangle -7500403 true true 104 238 195 247
Rectangle -7500403 true true 105 201 196 210
Polygon -6459832 true false 105 120 195 120 195 165 105 165
Rectangle -7500403 true true 104 165 195 174
Rectangle -16777216 true false 104 165 114 300
Rectangle -16777216 true false 186 165 196 300
Line -16777216 false 105 165 105 120
Line -16777216 false 105 120 195 120
Line -16777216 false 195 120 195 165
Rectangle -955883 true false 111 141 147 150
Rectangle -955883 true false 153 141 189 150
Polygon -1184463 true false 149 178 152 180 148 191 182 191 176 179 176 176
Polygon -1184463 true false 117 179 120 181 116 192 150 192 144 180 144 177
Rectangle -13345367 true false 150 258 171 267
Rectangle -13345367 true false 112 154 133 163
Rectangle -13345367 true false 119 253 140 262
Rectangle -13345367 true false 163 154 184 163
Polygon -13840069 true false 122 210 146 218 148 227 140 232 125 224 118 217
Polygon -13840069 true false 156 212 180 220 182 229 174 234 159 226 152 219
Circle -5825686 true false 118 117 18
Circle -5825686 true false 142 115 18
Circle -5825686 true false 167 117 18

empty top shelf x4
false
0
Polygon -7500403 true true 0 180 0 285 45 300 255 300 255 195 255 180
Polygon -16777216 true false 0 270 45 285 45 300 0 285 0 270
Rectangle -16777216 true false 45 285 300 300
Rectangle -16777216 true false 121 181 130 285
Rectangle -16777216 true false 0 181 9 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 45 195 0 180 255 180 300 195
Rectangle -16777216 true false 45 195 300 200
Rectangle -16777216 true false 45 225 300 230
Polygon -16777216 true false 1 181 45 195 45 200 1 186 1 182 1 182
Polygon -6459832 true false 45 225 0 210 255 210 300 225
Polygon -6459832 true false 45 255 0 240 255 240 300 255
Polygon -6459832 true false 45 285 0 270 255 270 300 285
Rectangle -1 true false 66 225 84 230
Rectangle -1 true false 108 225 126 230
Rectangle -1 true false 192 225 210 230
Rectangle -1 true false 66 195 84 200
Rectangle -1 true false 108 195 126 200
Rectangle -1 true false 192 195 210 200
Rectangle -16777216 true false 45 255 300 260
Rectangle -1 true false 66 255 84 260
Rectangle -1 true false 108 255 126 260
Rectangle -1 true false 192 255 210 260
Rectangle -16777216 true false 45 285 300 290
Rectangle -1 true false 66 285 84 290
Rectangle -1 true false 108 285 126 290
Rectangle -1 true false 192 285 210 290
Polygon -16777216 true false 1 271 45 285 45 290 1 276 1 272 1 272
Polygon -16777216 true false 1 241 45 255 45 260 1 246 1 242 1 242
Polygon -16777216 true false 1 211 45 225 45 230 1 216 1 212 1 212
Rectangle -16777216 true false 45 196 54 300
Rectangle -16777216 true false 291 196 300 300
Rectangle -16777216 true false 165 196 174 300
Rectangle -1 true false 237 285 255 290
Rectangle -1 true false 237 255 255 260
Rectangle -1 true false 237 225 255 230
Rectangle -1 true false 237 195 255 200

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flipped accacia tree
false
0
Polygon -6459832 true false 90 87 73 77 69 80 86 89
Polygon -6459832 true false 154 63 151 73 151 81 145 81 145 71 149 62
Polygon -14835848 true false 117 79 130 78 139 71 133 64 121 62 101 65 89 58 70 61 61 71 42 77 35 87 45 88 63 88 68 82 80 80 89 81 103 86 111 81
Polygon -14835848 true false 197 61 210 60 219 53 213 46 201 44 181 47 169 40 150 43 141 53 122 59 115 69 125 70 143 70 148 64 160 62 169 63 183 68 191 63
Polygon -7500403 true true 152 62 148 70 147 80 146 81 146 71 149 63
Polygon -6459832 true false 149 298 119 298 118 269 124 241 140 215 148 189 140 176 126 164 109 165 83 154 68 141 60 133 37 124 31 114 38 112 43 122 62 127 71 134 81 141 93 153 106 158 118 158 132 157 144 164 137 145 127 133 117 123 110 109 116 109 126 126 139 138 148 154 155 168 157 179 161 188 160 201 169 196 171 181 169 173 174 166 179 156 180 145 176 132 165 119 150 111 144 103 152 104 156 110 168 116 175 119 172 115 172 106 175 103 181 105 177 111 179 118 178 126 184 138 185 151 186 158 193 151 201 140 209 130 211 116 216 99 229 95 241 96 229 102 221 106 217 129 206 146 194 162 185 168 178 176 178 185 174 203 165 212 155 220 149 239 145 258 145 272 147 292
Polygon -7500403 true true 127 297 126 266 131 245 143 221 151 194 149 179 135 165 123 162 142 177 148 190 145 202 140 217 125 240 121 258 119 270 121 296
Polygon -7500403 true true 162 201 168 196 170 185 169 175 181 157 179 136 178 132 167 120 151 112 145 103 148 104 152 109 169 118 173 123 180 131 182 156 179 166 171 178 171 183 169 194
Polygon -7500403 true true 231 95 217 100 209 118 209 128 197 147 185 159 191 158 199 147 209 135 211 124 211 118 215 107 219 102
Polygon -7500403 true true 175 104 171 109 171 115 174 118 172 111 175 108
Polygon -7500403 true true 112 111 119 124 125 129 128 134 136 143 145 165 144 157 138 142 129 132 121 125 118 122
Polygon -7500403 true true 32 114 41 126 56 130 60 133 73 145 84 154 101 161 84 152 70 140 62 131 55 128 43 125
Polygon -10899396 true false 233 104 252 109 272 101 284 89 293 90 291 80 275 77 257 73 241 65 229 49 193 47 169 67 167 81 159 84 148 78 122 59 97 71 84 87 53 85 41 75 30 76 23 88 10 97 -4 108 1 120 18 123 34 121 34 115 39 114 43 121 60 120 63 112 65 105 69 102 86 108 89 117 92 119 99 121 108 119 111 114 114 109 122 112 129 113 134 111 141 110 144 106 152 106 157 107 163 110 173 107 176 105 188 107 200 109 209 103 216 100 216 100 228 97 236 97
Polygon -14835848 true false 242 76 241 64 231 50 214 49 206 42 181 47 176 53 178 59 178 55 182 48 204 46 218 54 229 53 232 59 237 64 236 68
Polygon -14835848 true false 292 84 285 78 269 77 251 83 249 87 250 88 254 86 267 81 276 81 284 83
Polygon -14835848 true false 216 91 210 79 196 74 181 74 166 81 157 85 156 91 160 86 172 84 181 78 195 78 208 81
Polygon -14835848 true false 142 79 125 65 112 67 101 70 87 82 79 81 83 86 90 84 100 75 103 71 110 69 128 71
Polygon -14835848 true false 11 96 18 90 34 89 52 95 54 99 53 100 49 98 36 93 27 93 19 95
Polygon -13840069 true false 163 298 168 287 165 280 165 287 161 291 159 287 159 284 154 288 155 298 146 298 146 293 148 289 143 295 142 297 142 286 135 279 140 288 138 292 133 291 133 284 129 292 130 298 121 291 122 287 116 291 120 297 107 297 113 286 104 281 109 286 103 299

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

fridge
false
12
Polygon -16777216 true false 4 18 47 3 46 208 3 226
Rectangle -16777216 true false 47 46 54 210
Polygon -16777216 true false 298 269 249 285 249 300 299 283 294 270
Polygon -14835848 true false 255 195 300 165 45 90 0 120
Polygon -16777216 true false 295 185 251 199 251 204 295 190 295 186 295 186
Polygon -14835848 true false 255 240 300 210 45 135 0 165
Polygon -14835848 true false 255 285 300 255 45 180 0 210
Polygon -16777216 true false 290 272 246 286 246 291 290 277 290 273 290 273
Polygon -16777216 true false 295 231 251 245 251 250 295 236 295 232 295 232
Rectangle -16777216 true false 0 30 9 225
Polygon -14835848 true false 255 150 300 120 45 45 0 75
Polygon -16777216 true false 294 139 250 153 250 158 294 144 294 140 294 140
Line -16777216 false 45 45 300 120
Polygon -16777216 true false 2 17 5 50 260 125 261 93
Polygon -16777216 true false 2 78 0 74 252 148 254 152
Polygon -16777216 true false 0 210 0 225 255 300 255 285
Polygon -16777216 true false 2 123 0 119 252 193 254 197
Polygon -16777216 true false 2 168 0 164 252 238 254 242
Polygon -16777216 true false 2 213 0 209 252 283 254 287
Rectangle -16777216 true false 255 150 255 300
Rectangle -16777216 true false 251 90 258 284
Polygon -16777216 true false 2 33 0 29 252 103 254 107
Polygon -16777216 true false 296 77 252 91 252 96 296 82 296 78 296 78
Polygon -16777216 true false 256 91 299 76 298 281 255 299
Polygon -5825686 true true 1 16 46 2 299 75 251 90
Polygon -1 false false 6 51 5 208 77 229 81 72
Polygon -1 false false 171 100 168 256 248 282 250 123
Polygon -1 false false 86 75 83 231 163 257 165 98
Line -1 false 63 81 22 205
Line -1 false 41 111 23 170
Line -1 false 65 126 52 162
Line -1 false 147 106 106 230
Line -1 false 233 133 192 257
Line -1 false 147 155 134 191
Line -1 false 234 183 221 219
Line -1 false 125 138 107 197
Line -1 false 210 162 192 221
Line -6459832 false 252 88 252 297
Circle -1 false false 62 146 11
Circle -1 false false 150 172 11
Circle -1 false false 234 196 11

fridge back 1
false
0
Rectangle -6459832 true false 30 240 270 255
Rectangle -6459832 true false 0 60 30 255
Rectangle -6459832 true false 270 60 300 255
Rectangle -16777216 true false 0 285 300 300
Polygon -7500403 true true 0 60 45 45 255 45 300 60
Rectangle -16777216 true false 0 255 300 290
Rectangle -16777216 true false 0 60 9 300
Rectangle -16777216 true false 291 60 300 300
Rectangle -16777216 true false 11 60 289 253
Circle -7500403 true true 30 75 30
Circle -7500403 true true 29 129 30
Circle -7500403 true true 30 183 30
Circle -7500403 true true 239 156 30
Circle -7500403 true true 236 209 30
Circle -7500403 true true 240 102 30
Circle -16777216 true false 33 78 24
Circle -16777216 true false 33 78 24
Circle -16777216 true false 242 159 24
Circle -16777216 true false 239 212 24
Circle -16777216 true false 243 105 24
Circle -16777216 true false 33 186 24
Circle -16777216 true false 32 132 24
Rectangle -7500403 true true 274 77 277 275
Rectangle -7500403 true true 45 210 256 213
Rectangle -7500403 true true 45 183 256 186
Rectangle -7500403 true true 44 129 255 132
Rectangle -7500403 true true 45 156 256 159
Rectangle -7500403 true true 45 102 256 105
Rectangle -7500403 true true 44 75 277 78
Rectangle -7500403 true true 44 75 277 78
Rectangle -7500403 true true 41 236 252 239
Polygon -16777216 false false 0 60 45 45 255 45 300 60
Rectangle -16777216 true false 47 78 60 102
Rectangle -16777216 true false 236 213 248 236
Rectangle -16777216 true false 45 186 61 210
Rectangle -16777216 true false 239 159 252 183
Rectangle -16777216 true false 44 132 60 156
Rectangle -16777216 true false 239 105 252 129
Polygon -16777216 true false 266 73 281 85 280 73
Circle -7500403 true true 256 75 21
Circle -16777216 true false 254 78 20
Rectangle -16777216 true false 250 78 262 90
Rectangle -16777216 true false 262 87 274 99
Rectangle -7500403 true true 120 265 178 283
Circle -7500403 true true 29 236 30
Circle -16777216 true false 32 239 24
Rectangle -7500403 true true 42 265 46 276
Rectangle -7500403 true true 43 274 276 277
Line -7500403 true 45 75 45 240
Line -7500403 true 60 75 60 240
Line -7500403 true 75 75 75 240
Line -7500403 true 90 75 90 240
Line -7500403 true 210 75 210 240
Line -7500403 true 195 75 195 240
Line -7500403 true 180 75 180 240
Line -7500403 true 150 75 150 240
Line -7500403 true 165 75 165 240
Line -7500403 true 135 75 135 240
Line -7500403 true 120 75 120 240
Line -7500403 true 105 75 105 240
Line -7500403 true 255 75 255 240
Line -7500403 true 240 75 240 240
Line -7500403 true 225 75 225 240

fridge back 2
false
0
Polygon -14835848 true false -2 105 28 106 28 126 -2 111 -2 105
Polygon -14835848 true false -2 135 28 136 28 156 -2 141 -2 135
Polygon -14835848 true false -2 180 28 181 28 201 -2 186 -2 180
Polygon -7500403 true true 30 300 0 270 0 210 15 195 15 105 0 75 0 45 30 60
Polygon -16777216 false false 0 45 0 75 15 105 15 195 0 210 0 270 30 300 30 60
Rectangle -6459832 true false 30 240 270 255
Rectangle -6459832 true false 28 61 58 256
Rectangle -6459832 true false 270 60 300 255
Polygon -7500403 true true 30 60 0 45 255 45 300 60
Rectangle -16777216 true false 28 255 300 300
Rectangle -16777216 true false 291 60 300 300
Rectangle -16777216 true false 30 60 289 254
Circle -7500403 true true 45 75 30
Circle -7500403 true true 44 129 30
Circle -7500403 true true 41 183 30
Circle -7500403 true true 239 156 30
Circle -7500403 true true 236 209 30
Circle -7500403 true true 240 102 30
Circle -16777216 true false 48 78 24
Circle -16777216 true false 242 159 24
Circle -16777216 true false 239 212 24
Circle -16777216 true false 243 105 24
Circle -16777216 true false 44 186 24
Circle -16777216 true false 47 132 24
Rectangle -7500403 true true 274 77 277 275
Rectangle -7500403 true true 53 210 256 213
Rectangle -7500403 true true 53 183 256 186
Rectangle -7500403 true true 57 129 255 132
Rectangle -7500403 true true 59 156 256 159
Rectangle -7500403 true true 60 102 256 105
Rectangle -7500403 true true 60 75 277 78
Rectangle -7500403 true true 54 236 252 239
Rectangle -16777216 true false 62 78 75 102
Rectangle -16777216 true false 236 213 248 236
Rectangle -16777216 true false 59 186 75 210
Rectangle -16777216 true false 239 159 252 183
Rectangle -16777216 true false 59 132 75 156
Rectangle -16777216 true false 239 105 252 129
Polygon -16777216 true false 266 73 281 85 280 73
Circle -7500403 true true 256 75 21
Circle -16777216 true false 254 78 20
Rectangle -16777216 true false 250 78 262 90
Rectangle -16777216 true false 262 87 274 99
Rectangle -7500403 true true 120 265 178 283
Circle -7500403 true true 41 236 30
Circle -16777216 true false 44 239 24
Rectangle -7500403 true true 53 265 57 276
Rectangle -7500403 true true 53 274 276 277
Line -7500403 true 60 75 60 240
Line -7500403 true 75 75 75 240
Line -7500403 true 90 75 90 240
Line -7500403 true 210 75 210 240
Line -7500403 true 195 75 195 240
Line -7500403 true 180 75 180 240
Line -7500403 true 150 75 150 240
Line -7500403 true 165 75 165 240
Line -7500403 true 135 75 135 240
Line -7500403 true 120 75 120 240
Line -7500403 true 105 75 105 240
Line -7500403 true 255 75 255 240
Line -7500403 true 240 75 240 240
Line -7500403 true 225 75 225 240
Polygon -16777216 false false 0 45 30 60 300 60 255 45
Line -16777216 false 28 61 26 298
Line -16777216 false 1 74 17 106
Line -16777216 false 16 197 2 211
Polygon -16777216 true false 1 109 16 115 16 120 1 114
Line -16777216 false 17 107 17 197
Polygon -16777216 true false 1 185 16 191 16 196 1 190
Polygon -16777216 true false 0 139 15 145 15 150 0 144
Polygon -1 false false 0 75 0 210 15 195 15 105

fruit island
false
0
Polygon -6459832 true false -1 301 -1 256 59 181 239 181 299 256 299 301
Line -16777216 false 0 255 300 255
Line -16777216 false 60 180 0 255
Line -16777216 false 0 255 0 300
Line -16777216 false 0 300 300 300
Line -16777216 false 300 300 300 255
Line -16777216 false 300 255 240 180
Line -16777216 false 240 150 240 150
Line -16777216 false 60 180 240 180
Polygon -6459832 true false 60 240 60 195 75 165 225 165 240 195 240 240
Line -16777216 false 60 195 75 165
Polygon -7500403 true true 240 195 300 255 240 225
Polygon -7500403 true true 239 179 225 165 232 181
Polygon -7500403 true true 60 195 0 255 60 225
Polygon -7500403 true true 61 179 75 165 68 181
Rectangle -16777216 false false 60 194 241 225
Line -16777216 false 225 165 240 195
Rectangle -6459832 true false 105 105 195 105
Rectangle -6459832 true false 105 150 195 180
Rectangle -16777216 false false 105 150 195 180
Polygon -6459832 true false 105 150 120 135 180 135 195 150
Polygon -16777216 false false 120 135 105 150 195 150 180 135
Rectangle -1 true false 6 261 30 273
Rectangle -1 true false 97 261 121 273
Rectangle -1 true false 214 261 238 273
Rectangle -1 true false 64 198 80 206
Rectangle -1 true false 118 198 134 206
Rectangle -1 true false 191 198 207 206
Rectangle -1 true false 113 154 129 162
Rectangle -1 true false 105 90 195 120
Rectangle -7500403 false true 105 90 195 120
Rectangle -16777216 true false 144 120 158 144
Circle -16777216 true false 8 263 8
Circle -16777216 true false 98 262 8
Circle -16777216 true false 217 262 8
Circle -16777216 true false 192 198 6
Circle -16777216 true false 118 199 6
Circle -16777216 true false 66 199 6
Circle -16777216 true false 115 155 6
Rectangle -16777216 true false 0 285 300 300
Circle -955883 true false 105 100 18
Circle -1184463 true false 140 101 16
Polygon -1184463 true false 145 104 147 98 152 103
Circle -955883 true false 16 238 12
Circle -955883 true false 24 226 12
Circle -955883 true false 76 240 12
Circle -955883 true false 63 240 12
Circle -955883 true false 51 240 12
Circle -955883 true false 40 239 12
Circle -955883 true false 28 239 12
Circle -955883 true false 85 231 12
Circle -955883 true false 75 227 12
Circle -955883 true false 62 228 12
Circle -955883 true false 49 227 12
Circle -955883 true false 36 227 12
Circle -955883 true false 85 217 12
Circle -955883 true false 72 215 12
Circle -955883 true false 60 215 12
Circle -955883 true false 49 215 12
Circle -955883 true false 35 216 12
Circle -955883 true false 98 215 12
Circle -955883 true false 89 205 12
Circle -955883 true false 75 203 12
Circle -955883 true false 62 203 12
Circle -955883 true false 49 203 12
Polygon -7500403 true true 112 194 90 255 111 226
Polygon -1184463 true false 155 203 157 208 157 213 153 219 144 222 144 226 156 225 161 221 166 214 166 208 162 203 158 202
Polygon -1184463 true false 122 201 124 206 124 211 120 217 111 220 111 224 123 223 128 219 133 212 133 206 129 201 125 200
Polygon -1184463 true false 166 230 168 235 168 240 164 246 155 249 155 253 167 252 172 248 177 241 177 235 173 230 169 229
Polygon -1184463 true false 140 228 142 233 142 238 138 244 129 247 129 251 141 250 146 246 151 239 151 233 147 228 143 227
Polygon -1184463 true false 112 226 114 231 114 236 110 242 101 245 101 249 113 248 118 244 123 237 123 231 119 226 115 225
Polygon -10899396 true false 155 204 157 208 161 214 163 219 162 227 159 230 160 234 165 234 170 228 171 218 168 209 161 204
Polygon -10899396 true false 123 201 125 205 129 211 131 216 130 224 127 227 128 231 133 231 138 225 139 215 136 206 129 201
Polygon -10899396 true false 166 223 168 227 172 233 174 238 173 246 170 249 171 253 176 253 181 247 182 237 179 228 172 223
Polygon -10899396 true false 141 225 143 229 147 235 149 240 148 248 145 251 146 255 151 255 156 249 157 239 154 230 147 225
Polygon -10899396 true false 111 224 113 228 117 234 119 239 118 247 115 250 116 254 121 254 126 248 127 238 124 229 117 224
Polygon -1184463 true false 154 203 164 210 169 219 171 225 171 230 174 231 177 224 176 215 172 209 168 206 162 202
Polygon -1184463 true false 124 201 134 208 139 217 141 223 141 228 144 229 147 222 146 213 142 207 138 204 132 200
Polygon -1184463 true false 167 225 177 232 182 241 184 247 184 252 187 253 190 246 189 237 185 231 181 228 175 224
Polygon -1184463 true false 141 226 151 233 156 242 158 248 158 253 161 254 164 247 163 238 159 232 155 229 149 225
Polygon -1184463 true false 114 225 124 232 129 241 131 247 131 252 134 253 137 246 136 237 132 231 128 228 122 224
Polygon -16777216 true false 166 223 170 221 172 227 170 229
Polygon -16777216 true false 140 225 144 223 146 229 144 231
Polygon -16777216 true false 119 197 123 195 125 201 123 203
Polygon -16777216 true false 110 222 114 220 116 226 114 228
Circle -2674135 true false 207 237 14
Circle -2674135 true false 195 228 14
Circle -2674135 true false 272 237 14
Circle -2674135 true false 257 236 14
Circle -2674135 true false 241 237 14
Circle -2674135 true false 224 237 14
Circle -2674135 true false 262 222 14
Circle -2674135 true false 247 223 14
Circle -2674135 true false 232 226 14
Circle -2674135 true false 215 224 14
Circle -2674135 true false 186 213 14
Circle -2674135 true false 183 196 14
Circle -2674135 true false 242 209 14
Circle -2674135 true false 225 212 14
Circle -2674135 true false 204 215 14
Circle -2674135 true false 231 197 14
Circle -2674135 true false 212 202 14
Circle -2674135 true false 197 201 14
Polygon -7500403 true true 182 194 207 255 182 225
Polygon -1184463 true false 121 94 123 99 123 104 119 110 110 113 110 117 122 116 127 112 132 105 132 99 128 94 124 93
Polygon -10899396 true false 120 91 122 95 126 101 128 106 127 114 124 117 125 121 130 121 135 115 136 105 133 96 126 91
Polygon -1184463 true false 114 225 124 232 129 241 131 247 131 252 134 253 137 246 136 237 132 231 128 228 122 224
Polygon -7500403 true true 112 194 90 255 111 226
Polygon -1184463 true false 121 94 131 101 136 110 138 116 138 121 141 122 144 115 143 106 139 100 135 97 129 93
Polygon -16777216 true false 119 90 123 88 125 94 123 96
Circle -2674135 true false 135 105 14
Polygon -955883 true false 138 107 143 110 145 105
Circle -1184463 true false 62 171 9
Circle -1184463 true false 57 180 9
Circle -1184463 true false 51 187 9
Circle -1184463 true false 46 194 9
Circle -1184463 true false 39 202 9
Circle -5825686 true false 147 107 12
Circle -5825686 true false 259 204 12
Circle -5825686 true false 234 175 12
Circle -5825686 true false 240 186 12
Circle -5825686 true false 250 195 12
Polygon -955883 true false 199 140 206 143 212 150 215 158 215 165 213 170 203 169 197 161 194 153 194 145
Polygon -1184463 true false 177 90 183 91 189 98 192 106 192 113 190 118 180 117 174 109 171 101 171 93
Polygon -955883 true false 180 94 186 99 189 108 189 115 186 107 185 103
Polygon -10899396 true false 178 101 177 106 181 113 184 113
Polygon -10899396 true false 202 154 201 159 205 166 208 166
Polygon -1184463 true false 201 144 207 149 210 158 210 165 207 157 206 153
Polygon -955883 true false 211 145 218 148 224 155 227 163 227 170 225 175 215 174 209 166 206 158 206 150
Polygon -10899396 true false 213 158 212 163 216 170 219 170
Polygon -1184463 true false 213 151 219 156 222 165 222 172 219 164 218 160
Polygon -1184463 true false 193 156 200 159 206 166 209 174 209 181 207 186 197 185 191 177 188 169 188 161
Polygon -10899396 true false 195 169 194 174 198 181 201 181
Polygon -955883 true false 194 161 200 166 203 175 203 182 200 174 199 170
Polygon -1184463 true false 209 160 216 163 222 170 225 178 225 185 223 190 213 189 207 181 204 173 204 165
Polygon -10899396 true false 211 172 210 177 214 184 217 184
Polygon -955883 true false 212 167 218 172 221 181 221 188 218 180 217 176
Circle -2674135 true false 218 188 14
Polygon -13840069 true false 116 162 118 165 119 173 117 180 114 182 116 173 115 168
Polygon -13840069 true false 105 162 103 165 102 173 104 180 107 182 105 173 106 168
Polygon -13840069 true false 109 162 108 171 109 184 112 176 112 168 111 158
Circle -14835848 true false 74 141 30
Polygon -13840069 true false 81 146 79 149 78 157 80 164 83 166 81 157 82 152
Polygon -13840069 true false 86 147 85 156 86 169 89 161 89 153 88 143
Polygon -13840069 true false 94 145 96 148 97 156 95 163 92 165 94 156 93 151
Polygon -2674135 true false 172 104 159 99 159 105 163 112 170 114 177 113 173 109
Polygon -14835848 true false 159 99 157 98 156 103 157 106 159 111 167 116 175 116 178 114 176 112 172 113 168 113 164 110 161 106
Circle -14835848 true false 72 155 30
Polygon -13840069 true false 80 162 78 165 77 173 79 180 82 182 80 173 81 168
Polygon -13840069 true false 85 161 84 170 85 183 88 175 88 167 87 157
Polygon -13840069 true false 92 160 94 163 95 171 93 178 90 180 92 171 91 166
Circle -14835848 true false 97 156 30
Circle -14835848 true false 126 157 30
Circle -14835848 true false 157 157 30
Polygon -13840069 true false 165 162 163 165 162 173 164 180 167 182 165 173 166 168
Polygon -13840069 true false 134 161 132 164 131 172 133 179 136 181 134 172 135 167
Polygon -13840069 true false 104 163 102 166 101 174 103 181 106 183 104 174 105 169
Polygon -13840069 true false 109 162 108 171 109 184 112 176 112 168 111 158
Polygon -13840069 true false 140 163 139 172 140 185 143 177 143 169 142 159
Polygon -13840069 true false 171 162 170 171 171 184 174 176 174 168 173 158
Polygon -13840069 true false 147 162 149 165 150 173 148 180 145 182 147 173 146 168
Polygon -13840069 true false 116 162 118 165 119 173 117 180 114 182 116 173 115 168
Polygon -13840069 true false 178 163 180 166 181 174 179 181 176 183 178 174 177 169
Polygon -14835848 true false 167 178 170 185 174 189 182 192 191 191 198 187 199 182 198 182 195 186 190 188 183 189 176 187 172 183 170 179
Polygon -14835848 true false 134 177 137 184 141 188 149 191 158 190 165 186 166 181 165 181 162 185 157 187 150 188 143 186 139 182 137 178
Polygon -14835848 true false 90 180 93 187 97 191 105 194 114 193 121 189 122 184 121 184 118 188 113 190 106 191 99 189 95 185 93 181
Polygon -14835848 true false 58 177 61 184 65 188 73 191 82 190 89 186 90 181 89 181 86 185 81 187 74 188 67 186 63 182 61 178
Polygon -2674135 true false 171 179 200 183 198 184 195 187 189 189 185 189 178 187 174 184
Polygon -2674135 true false 137 177 166 181 164 182 161 185 155 187 151 187 144 185 140 182
Polygon -2674135 true false 92 181 121 185 119 186 116 189 110 191 106 191 99 189 95 186
Polygon -2674135 true false 60 178 89 182 87 183 84 186 78 188 74 188 67 186 63 183
Circle -13840069 true false 120 123 21
Circle -13840069 true false 120 123 21
Circle -13840069 true false 142 130 21
Circle -13840069 true false 165 123 21
Polygon -1184463 true false 135 183 137 188 137 193 133 199 124 202 124 206 136 205 141 201 146 194 146 188 142 183 138 182
Polygon -10899396 true false 134 179 136 183 140 189 142 194 141 202 138 205 139 209 144 209 149 203 150 193 147 184 140 179
Polygon -1184463 true false 133 181 143 188 148 197 150 203 150 208 153 209 156 202 155 193 151 187 147 184 141 180
Polygon -16777216 true false 152 200 156 198 158 204 156 206
Polygon -16777216 true false 131 177 135 175 137 181 135 183
Polygon -13840069 true false 99 137 101 141 108 145 116 146 121 144 127 139 125 138 117 142 110 143 103 140
Polygon -955883 true false 101 138 107 143 112 143 117 142 120 140 123 138
Polygon -13840069 true false 119 143 121 147 128 151 136 152 141 150 147 145 145 144 137 148 130 149 123 146
Polygon -955883 true false 122 145 128 150 133 150 138 149 141 147 144 145
Polygon -13840069 true false 155 143 157 147 164 151 172 152 177 150 183 145 181 144 173 148 166 149 159 146
Polygon -955883 true false 159 144 165 149 170 149 175 148 178 146 181 144

green house
false
0
Polygon -7500403 true true 37 135 37 226 137 286 139 133 38 130 38 130
Rectangle -6459832 true false 135 165 300 285
Polygon -16777216 true false 1 119 1 269 5 266 5 118
Polygon -16777216 true false 35 90 35 226 39 220 39 89
Polygon -16777216 true false 0 120 30 90 120 30 225 75 300 165 105 165
Polygon -16777216 true false 100 164 130 134 225 75 310 164
Rectangle -14835848 true false 151 185 225 260
Rectangle -14835848 true false 242 186 302 224
Circle -14835848 true false 194 101 52
Polygon -16777216 true false 39 154 68 165 67 239 39 223
Polygon -16777216 true false 68 166 93 176 94 258 66 242
Polygon -14835848 true false 1 270 38 222 137 285 101 286
Polygon -16777216 true false 100 161 100 289 104 288 104 161
Polygon -13840069 true false 273 287 277 279 275 271 281 280 278 286 287 282 287 274 293 270 289 279 292 284 297 281 297 278 299 287
Polygon -13840069 true false 165 287 169 279 167 271 173 280 170 286 179 282 179 274 185 270 181 279 184 284 189 281 189 278 191 287
Polygon -13840069 true false 205 287 203 277 205 269 199 278 202 284 193 280 193 272 187 268 191 277 188 282 192 285 192 286 200 287
Polygon -13840069 true false 100 286 94 277 86 277 93 281 99 288 92 286 87 287 103 288 106 274 112 279 109 281 105 288
Polygon -7500403 true true 42 227 16 259 73 274 86 258

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

liquid fridge
false
0
Polygon -16777216 true false 4 18 47 3 46 208 3 226
Rectangle -16777216 true false 47 46 54 210
Polygon -16777216 true false 298 269 249 285 249 300 299 283 294 270
Polygon -14835848 true false 255 285 300 255 45 180 0 210
Polygon -16777216 true false 290 272 246 286 246 291 290 277 290 273 290 273
Rectangle -16777216 true false 0 30 9 225
Line -16777216 false 45 45 300 120
Polygon -16777216 true false 2 78 0 74 252 148 254 152
Polygon -16777216 true false 0 210 0 225 255 300 255 285
Polygon -16777216 true false 2 213 0 209 252 283 254 287
Rectangle -16777216 true false 255 150 255 300
Polygon -16777216 true false 2 33 0 29 252 103 254 107
Polygon -16777216 true false 296 77 252 91 252 96 296 82 296 78 296 78
Polygon -7500403 true true 1 16 46 2 299 75 251 90
Polygon -955883 true false 43 165 43 168 40 170 39 172 39 176 38 193 42 196 48 195 53 193 54 171 51 168 51 165
Polygon -955883 true false 25 176 25 179 22 181 21 183 21 187 20 204 24 207 30 206 35 204 36 182 33 179 33 176
Polygon -1 true false 39 177 53 177 53 188 38 188
Polygon -1 true false 21 187 35 187 35 198 20 198
Polygon -1 true false 24 174 24 177 33 177 33 174
Polygon -955883 true false 46 180 46 183 43 185 42 187 42 191 41 208 45 211 51 210 56 208 57 186 54 183 54 180
Polygon -955883 true false 62 167 62 170 59 172 58 174 58 178 57 195 61 198 67 197 72 195 73 173 70 170 70 167
Polygon -1 true false 58 181 72 181 72 192 57 192
Polygon -1 true false 42 192 56 192 56 203 41 203
Polygon -1 true false 45 179 45 182 54 182 54 179
Polygon -1184463 true false 80 169 80 172 77 174 76 176 76 180 75 197 79 200 85 199 90 197 91 175 88 172 88 169
Polygon -1184463 true false 62 183 62 186 59 188 58 190 58 194 57 211 61 214 67 213 72 211 73 189 70 186 70 183
Polygon -1184463 true false 97 176 97 179 94 181 93 183 93 187 92 204 96 207 102 206 107 204 108 182 105 179 105 176
Polygon -1 true false 93 189 107 189 107 200 92 200
Polygon -1 true false 77 179 91 179 91 190 76 190
Polygon -1 true false 58 194 72 194 72 205 57 205
Polygon -1184463 true false 81 190 81 193 78 195 77 197 77 201 76 218 80 221 86 220 91 218 92 196 89 193 89 190
Polygon -1 true false 77 202 91 202 91 213 76 213
Polygon -1 true false 79 191 79 194 88 194 88 191
Polygon -1 true false 61 183 61 186 70 186 70 183
Polygon -8630108 true false 141 185 141 188 138 191 136 192 135 197 134 201 134 219 139 223 148 223 153 220 154 199 151 192 149 189 149 184
Polygon -955883 true false 167 194 167 197 164 200 162 201 161 206 160 210 160 228 165 232 174 232 179 229 180 208 177 201 175 198 175 193
Polygon -955883 true false 145 209 145 212 142 215 140 216 139 221 138 225 138 243 143 247 152 247 157 244 158 223 155 216 153 213 153 208
Polygon -16777216 true false 192 197 192 200 189 203 187 204 186 209 185 213 185 231 190 235 199 235 204 232 205 211 202 204 200 201 200 196
Polygon -16777216 true false 171 216 171 219 168 222 166 223 165 228 164 232 164 250 169 254 178 254 183 251 184 230 181 223 179 220 179 215
Polygon -1184463 true false 137 224 157 225 157 236 138 237
Polygon -2674135 true false 163 231 183 232 183 243 164 244
Polygon -16777216 true false 216 210 216 213 213 216 211 217 210 222 209 226 209 244 214 248 223 248 228 245 229 224 226 217 224 214 224 209
Polygon -16777216 true false 195 222 195 225 192 228 190 229 189 234 188 238 188 256 193 260 202 260 207 257 208 236 205 229 203 226 203 221
Polygon -2674135 true false 188 238 208 239 208 250 189 251
Polygon -11221820 true false 238 217 238 220 235 223 233 224 232 229 231 233 231 251 236 255 245 255 250 252 251 231 248 224 246 221 246 216
Polygon -11221820 true false 221 228 221 231 218 234 216 235 215 240 214 244 214 262 219 266 228 266 233 263 234 242 231 235 229 232 229 227
Polygon -13345367 true false 213 244 233 245 233 256 214 257
Polygon -1184463 true false 116 182 116 185 113 187 112 189 112 193 111 210 115 213 121 212 126 210 127 188 124 185 124 182
Polygon -1 true false 112 194 126 194 126 205 111 205
Polygon -1184463 true false 98 199 98 202 95 204 94 206 94 210 93 227 97 230 103 229 108 227 109 205 106 202 106 199
Polygon -1 true false 94 211 108 211 108 222 93 222
Polygon -1 true false 97 202 97 205 106 205 106 202
Polygon -8630108 true false 120 199 120 202 117 205 115 206 114 211 113 215 113 233 118 237 127 237 132 234 133 213 130 206 128 203 128 198
Polygon -5825686 true false 113 214 133 215 133 226 114 227
Polygon -14835848 true false 255 240 300 210 45 135 0 165
Polygon -955883 true false 45 120 45 123 42 125 41 127 41 131 40 148 44 151 50 150 55 148 56 126 53 123 53 120
Polygon -1 true false 41 131 55 131 55 142 40 142
Polygon -2674135 true false 63 124 63 127 60 129 59 131 59 135 58 152 62 155 68 154 73 152 74 130 71 127 71 124
Polygon -955883 true false 25 133 25 136 22 138 21 140 21 144 20 161 24 164 30 163 35 161 36 139 33 136 33 133
Polygon -1 true false 21 146 35 146 35 157 20 157
Polygon -1 true false 24 133 24 136 33 136 33 133
Polygon -1 true false 59 135 73 135 73 146 58 146
Polygon -2674135 true false 46 144 46 147 43 149 42 151 42 155 41 172 45 175 51 174 56 172 57 150 54 147 54 144
Polygon -1 true false 42 155 56 155 56 166 41 166
Polygon -1 true false 46 145 46 148 55 148 55 145
Polygon -2674135 true false 81 128 81 131 78 133 77 135 77 139 76 156 80 159 86 158 91 156 92 134 89 131 89 128
Polygon -1 true false 77 140 91 140 91 151 76 151
Polygon -2674135 true false 66 148 66 151 63 153 62 155 62 159 61 176 65 179 71 178 76 176 77 154 74 151 74 148
Polygon -1 true false 62 158 76 158 76 169 61 169
Polygon -1 true false 64 147 64 150 73 150 73 147
Polygon -10899396 true false 100 133 100 136 97 138 96 140 96 144 95 161 99 164 105 163 110 161 111 139 108 136 108 133
Polygon -1 true false 96 144 110 144 110 155 95 155
Polygon -10899396 true false 85 152 85 155 82 157 81 159 81 163 80 180 84 183 90 182 95 180 96 158 93 155 93 152
Polygon -1 true false 82 162 96 162 96 173 81 173
Polygon -1 true false 83 153 83 156 92 156 92 153
Polygon -10899396 true false 119 141 119 144 116 146 115 148 115 152 114 169 118 172 124 171 129 169 130 147 127 144 127 141
Polygon -1 true false 115 152 129 152 129 163 114 163
Polygon -10899396 true false 107 158 107 161 104 163 103 165 103 169 102 186 106 189 112 188 117 186 118 164 115 161 115 158
Polygon -1 true false 103 169 117 169 117 180 102 180
Polygon -1 true false 105 156 105 159 114 159 114 156
Polygon -8630108 true false 150 144 150 147 147 150 145 151 144 156 143 160 143 178 148 182 157 182 162 179 163 158 160 151 158 148 158 143
Polygon -8630108 true false 128 157 128 160 125 163 123 164 122 169 121 173 121 191 126 195 135 195 140 192 141 171 138 164 136 161 136 156
Polygon -5825686 true false 121 171 141 172 141 183 122 184
Polygon -955883 true false 177 155 177 158 174 161 172 162 171 167 170 171 170 189 175 193 184 193 189 190 190 169 187 162 185 159 185 154
Polygon -1184463 true false 169 171 189 172 189 183 170 184
Polygon -5825686 true false 143 158 163 159 163 170 144 171
Polygon -955883 true false 154 165 154 168 151 171 149 172 148 177 147 181 147 199 152 203 161 203 166 200 167 179 164 172 162 169 162 164
Polygon -1184463 true false 147 181 167 182 167 193 148 194
Polygon -16777216 true false 201 161 201 164 198 167 196 168 195 173 194 177 194 195 199 199 208 199 213 196 214 175 211 168 209 165 209 160
Polygon -16777216 true false 179 169 179 172 176 175 174 176 173 181 172 185 172 203 177 207 186 207 191 204 192 183 189 176 187 173 187 168
Polygon -2674135 true false 194 177 214 178 214 189 195 190
Polygon -2674135 true false 172 186 192 187 192 198 173 199
Polygon -16777216 true false 224 168 224 171 221 174 219 175 218 180 217 184 217 202 222 206 231 206 236 203 237 182 234 175 232 172 232 167
Polygon -16777216 true false 203 177 203 180 200 183 198 184 197 189 196 193 196 211 201 215 210 215 215 212 216 191 213 184 211 181 211 176
Polygon -2674135 true false 216 186 236 187 236 198 217 199
Polygon -2674135 true false 195 193 215 194 215 205 196 206
Polygon -11221820 true false 226 186 226 189 223 192 221 193 220 198 219 202 219 220 224 224 233 224 238 221 239 200 236 193 234 190 234 185
Polygon -11221820 true false 247 174 247 177 244 180 242 181 241 186 240 190 240 208 245 212 254 212 259 209 260 188 257 181 255 178 255 173
Polygon -13345367 true false 239 188 259 189 259 200 240 201
Polygon -13345367 true false 219 203 239 204 239 215 220 216
Polygon -14835848 true false 255 195 300 165 45 90 0 120
Polygon -16777216 true false 2 123 0 119 252 193 254 197
Polygon -16777216 true false 2 168 0 164 252 238 254 242
Polygon -11221820 true false 38 78 38 80 34 83 33 103 35 104 43 106 45 103 45 81 42 80 42 77
Polygon -13345367 true false 33 88 45 88 46 97 33 97
Polygon -1 false false 39 89 37 93 38 94 41 94 42 92
Polygon -11221820 true false 23 87 23 89 19 92 18 113 22 114 28 115 30 112 30 90 27 89 27 86
Polygon -13345367 true false 18 96 30 96 31 105 18 105
Polygon -1 false false 23 97 21 101 22 102 25 102 26 100
Polygon -1 true false 22 86 22 89 28 88 28 87
Polygon -11221820 true false 53 83 53 85 49 88 48 108 50 109 58 111 60 108 60 86 57 85 57 82
Polygon -13345367 true false 48 94 60 94 61 103 48 103
Polygon -1 false false 54 95 52 99 53 100 56 100 57 98
Polygon -11221820 true false 41 94 41 96 37 99 37 120 40 122 46 122 48 119 48 97 45 96 45 93
Polygon -13345367 true false 36 103 48 103 49 112 36 112
Polygon -1 false false 41 105 39 109 40 110 43 110 44 108
Polygon -1 true false 39 94 39 97 45 96 45 95
Polygon -11221820 true false 74 89 74 91 70 94 70 115 73 117 79 117 81 114 81 92 78 91 78 88
Polygon -11221820 true false 60 97 60 99 56 102 56 123 59 125 65 125 67 122 67 100 64 99 64 96
Polygon -13345367 true false 69 100 81 100 82 109 69 109
Polygon -13345367 true false 56 107 68 107 69 116 56 116
Polygon -1 false false 75 102 73 106 74 107 77 107 78 105
Polygon -1 false false 61 109 59 113 60 114 63 114 64 112
Polygon -1 true false 59 97 59 100 65 99 65 98
Polygon -11221820 true false 95 96 95 98 91 101 91 122 94 124 100 124 102 121 102 99 99 98 99 95
Polygon -11221820 true false 82 104 82 106 78 109 78 130 81 132 87 132 89 129 89 107 86 106 86 103
Polygon -13345367 true false 90 107 102 107 103 116 90 116
Polygon -13345367 true false 77 113 89 113 90 122 77 122
Polygon -1 false false 95 108 93 112 94 113 97 113 98 111
Polygon -1 false false 83 115 81 119 82 120 85 120 86 118
Polygon -1 true false 82 104 82 107 88 106 88 103
Polygon -1184463 true false 119 100 119 102 115 105 115 126 118 128 124 128 126 125 126 103 123 102 123 99
Polygon -1184463 true false 103 106 103 108 99 111 99 132 102 134 108 134 110 131 110 109 107 108 107 105
Polygon -1 true false 114 112 126 112 127 121 114 121
Polygon -1 true false 98 116 110 116 111 125 98 125
Polygon -1 true false 103 107 103 110 109 109 109 106
Polygon -1184463 true false 141 105 141 107 137 110 137 131 140 133 146 133 148 130 148 108 145 107 145 104
Polygon -1 true false 137 115 149 115 150 124 137 124
Polygon -1184463 true false 127 116 127 118 123 121 123 142 126 144 132 144 134 141 134 119 131 118 131 115
Polygon -1 true false 122 127 134 127 135 136 122 136
Polygon -1 true false 125 117 125 120 131 119 131 116
Polygon -10899396 true false 149 123 149 125 145 128 145 149 148 151 154 151 156 148 156 126 153 125 153 122
Polygon -10899396 true false 162 113 162 115 158 118 158 139 161 141 167 141 169 138 169 116 166 115 166 112
Polygon -1 true false 144 134 156 134 156 143 144 143
Polygon -1 true false 158 123 170 123 171 132 158 132
Polygon -1 true false 147 124 147 127 153 126 153 123
Polygon -10899396 true false 169 131 169 133 165 136 165 157 168 159 174 159 176 156 176 134 173 133 173 130
Polygon -10899396 true false 182 119 182 121 178 124 178 145 181 147 187 147 189 144 189 122 186 121 186 118
Polygon -1 true false 163 141 175 141 176 150 163 150
Polygon -1 true false 178 130 190 130 190 139 178 139
Polygon -1 true false 167 133 167 136 173 135 173 132
Polygon -955883 true false 199 121 199 123 195 126 195 147 198 149 204 149 206 146 206 124 203 123 203 120
Polygon -955883 true false 186 137 186 139 182 142 182 163 185 165 191 165 193 162 193 140 190 139 190 136
Polygon -1184463 true false 194 133 206 133 207 142 194 142
Polygon -1184463 true false 181 150 193 150 194 159 181 159
Polygon -955883 true false 204 144 204 146 200 149 200 170 203 172 209 172 211 169 211 147 208 146 208 143
Polygon -955883 true false 216 133 216 135 212 138 212 159 215 161 221 161 223 158 223 136 220 135 220 132
Polygon -1184463 true false 211 145 223 145 224 154 211 154
Polygon -1184463 true false 200 155 212 155 213 164 200 164
Polygon -1184463 true false 202 145 202 148 208 147 208 144
Polygon -1184463 true false 184 138 184 141 190 140 190 137
Polygon -16777216 true false 233 134 233 136 229 139 229 160 232 162 238 162 240 159 240 137 237 136 237 133
Polygon -16777216 true false 223 148 223 150 219 153 219 174 222 176 228 176 230 173 230 151 227 150 227 147
Polygon -2674135 true false 218 160 230 160 231 169 218 169
Polygon -2674135 true false 228 144 240 144 241 153 229 153
Polygon -16777216 true false 247 142 247 144 243 147 243 168 246 170 252 170 254 167 254 145 251 144 251 141
Polygon -16777216 true false 236 153 236 155 232 158 232 179 235 181 241 181 243 178 243 156 240 155 240 152
Polygon -2674135 true false 243 153 255 153 256 162 243 162
Polygon -2674135 true false 231 166 243 166 244 175 231 175
Polygon -2674135 true false 235 153 235 156 241 155 241 152
Polygon -2674135 true false 221 148 221 151 227 150 227 147
Polygon -14835848 true false 255 150 300 120 45 45 0 75
Polygon -11221820 true false 23 47 23 49 19 52 18 73 22 74 28 75 30 72 30 50 27 49 27 46
Polygon -13345367 true false 18 58 30 58 31 67 18 67
Polygon -1 false false 23 59 21 63 22 64 25 64 26 62
Polygon -11221820 true false 40 51 40 53 36 56 35 77 39 78 45 79 47 76 47 54 44 53 44 50
Polygon -11221820 true false 122 77 122 79 118 82 117 103 121 104 127 105 129 102 129 80 126 79 126 76
Polygon -11221820 true false 105 73 105 75 101 78 100 99 104 100 110 101 112 98 112 76 109 75 109 72
Polygon -11221820 true false 90 68 90 70 86 73 85 94 89 95 95 96 97 93 97 71 94 70 94 67
Polygon -11221820 true false 74 61 74 63 70 66 69 87 73 88 79 89 81 86 81 64 78 63 78 60
Polygon -11221820 true false 57 57 57 59 53 62 52 83 56 84 62 85 64 82 64 60 61 59 61 56
Polygon -11221820 true false 171 92 171 94 167 97 166 118 170 119 176 120 178 117 178 95 175 94 175 91
Polygon -11221820 true false 155 85 155 87 151 90 150 111 154 112 160 113 162 110 162 88 159 87 159 84
Polygon -11221820 true false 139 80 139 82 135 85 134 106 138 107 144 108 146 105 146 83 143 82 143 79
Polygon -6459832 true false 205 101 205 103 201 106 200 127 204 128 210 129 212 126 212 104 209 103 209 100
Polygon -6459832 true false 189 96 189 98 185 101 184 122 188 123 194 124 196 121 196 99 193 98 193 95
Polygon -6459832 true false 239 111 239 113 235 116 234 137 238 138 244 139 246 136 246 114 243 113 243 110
Polygon -6459832 true false 221 106 221 108 217 111 216 132 220 133 226 134 228 131 228 109 225 108 225 105
Polygon -13345367 true false 35 63 47 63 48 72 35 72
Polygon -13345367 true false 165 102 177 102 178 111 165 111
Polygon -13345367 true false 150 95 162 95 163 104 150 104
Polygon -13345367 true false 134 90 146 90 147 99 134 99
Polygon -13345367 true false 117 88 129 88 130 97 117 97
Polygon -13345367 true false 100 85 112 85 113 94 100 94
Polygon -13345367 true false 85 80 97 80 98 89 85 89
Polygon -13345367 true false 68 72 80 72 81 81 68 81
Polygon -13345367 true false 51 68 63 68 64 77 51 77
Polygon -1 false false 41 65 39 69 40 70 43 70 44 68
Polygon -1 false false 171 103 169 107 170 108 173 108 174 106
Polygon -1 false false 155 95 153 99 154 100 157 100 158 98
Polygon -1 false false 140 91 138 95 139 96 142 96 143 94
Polygon -1 false false 122 89 120 93 121 94 124 94 125 92
Polygon -1 false false 106 87 104 91 105 92 108 92 109 90
Polygon -1 false false 91 82 89 86 90 87 93 87 94 85
Polygon -1 false false 74 74 72 78 73 79 76 79 77 77
Polygon -1 false false 56 69 54 73 55 74 58 74 59 72
Polygon -13840069 true false 183 107 195 107 196 116 183 116
Polygon -13840069 true false 234 122 246 122 247 131 234 131
Polygon -13840069 true false 215 117 227 117 228 126 215 126
Polygon -13840069 true false 199 113 211 113 212 122 199 122
Polygon -16777216 true false 2 17 5 50 260 125 261 93
Rectangle -16777216 true false 251 90 258 284
Polygon -16777216 true false 258 89 301 74 300 279 257 297
Line -6459832 false 253 88 253 297
Circle -6459832 false false 189 111 4
Circle -6459832 false false 240 125 4
Circle -6459832 false false 236 124 4
Circle -6459832 false false 220 121 4
Circle -6459832 false false 217 117 4
Circle -6459832 false false 205 117 4
Circle -6459832 false false 202 115 4
Circle -6459832 false false 185 108 4
Polygon -1 false false 7 53 6 210 78 231 82 74
Polygon -1 false false 86 75 83 231 163 257 165 98
Polygon -1 false false 171 100 168 256 248 282 250 123
Line -1 false 41 111 23 170
Line -1 false 63 81 22 205
Line -1 false 50 141 37 177
Circle -1 false false 64 146 11
Line -1 false 125 138 107 197
Line -1 false 147 106 106 230
Line -1 false 132 170 119 206
Line -1 false 195 162 177 221
Line -1 false 218 133 177 257
Line -1 false 204 198 191 234
Circle -1 false false 234 196 11
Circle -1 false false 149 171 11
Polygon -1 false false 228 206 226 210 227 211 230 211 231 209
Polygon -1 false false 223 248 221 252 222 253 225 253 226 251

middle freezer
false
0
Polygon -1 true false 0 225 0 285 45 300 300 300 300 240 255 225
Polygon -16777216 true false 0 270 45 285 45 300 0 285 0 270
Rectangle -16777216 true false 45 285 300 300
Rectangle -16777216 true false 0 225 9 285
Polygon -14835848 true false 45 240 0 225 255 225 300 240
Rectangle -16777216 true false 45 240 300 245
Rectangle -16777216 true false 45 285 300 290
Polygon -16777216 true false 1 271 45 285 45 290 1 276 1 272 1 272
Polygon -16777216 true false 1 226 45 240 45 245 1 231 1 227 1 227
Rectangle -16777216 true false 45 240 54 300
Rectangle -16777216 true false 285 240 300 300
Rectangle -16777216 true false 165 240 174 300
Rectangle -16777216 true false 248 225 255 244
Rectangle -16777216 true false 1 225 8 244
Polygon -1 false false 300 240 225 180 255 225
Line -1 false 75 180 225 180
Polygon -16777216 true false 133 226 133 226 163 241 178 241 148 226
Line -1 false 151 180 176 241
Polygon -1 false false 0 225 45 240 300 240 255 225
Polygon -1 false false 83 225
Line -1 false 152 182 132 224
Rectangle -1 true false 75 165 225 180
Rectangle -7500403 false true 75 165 225 180
Polygon -13791810 false false 61 267 61 276 70 278 71 270
Polygon -13791810 false false 56 253 61 262 71 258 67 250
Polygon -13791810 false false 78 261 76 271 89 274 89 261
Polygon -8630108 true false 91 228 97 220 95 216 135 216 133 218 137 228 138 233 104 234
Polygon -1184463 true false 42 227 43 236 46 236 46 226
Polygon -2064490 true false 99 231 105 223 103 219 143 219 141 221 145 231 146 236 112 237
Polygon -8630108 true false 104 239 110 231 108 227 148 227 146 229 151 237 152 239 118 239
Polygon -2064490 true false 51 226 57 218 55 214 95 214 93 216 97 226 98 231 64 232
Polygon -8630108 true false 55 230 61 222 59 218 99 218 97 220 102 228 102 234 70 235
Polygon -2064490 true false 63 235 69 227 67 223 107 223 105 225 109 235 110 240 76 241
Polygon -8630108 true false 9 226 15 218 13 214 53 214 51 216 55 226 56 231 22 232
Polygon -2064490 true false 20 231 26 223 24 219 64 219 62 221 66 231 67 236 33 237
Polygon -8630108 true false 31 236 37 228 35 224 75 224 73 226 78 234 78 240 46 241
Polygon -1184463 true false 39 227 43 236 46 235 43 229
Polygon -1184463 true false 46 230 50 239 53 239 50 229
Polygon -1184463 true false 57 229 56 240 58 241 62 228
Polygon -1184463 true false 64 229 64 240 68 239 69 230
Polygon -1184463 true false 77 227 81 236 84 235 81 229
Polygon -1184463 true false 83 226 87 235 90 235 87 225
Polygon -1184463 true false 92 227 91 238 93 239 97 226
Polygon -1184463 true false 97 228 97 239 101 238 102 229
Polygon -1184463 true false 110 229 114 238 117 237 114 231
Polygon -1184463 true false 115 227 119 236 122 236 119 226
Polygon -1184463 true false 124 228 123 239 125 240 129 227
Polygon -1184463 true false 130 230 130 241 134 240 135 231
Polygon -1 false false 81 187 59 236 165 235 147 187
Polygon -1 false false 0 225 75 180 45 240
Line -1 false 98 190 83 224
Line -1 false 103 202 88 236
Circle -1 false false 101 216 16
Polygon -1 true false 158 230 203 230 212 239 176 239
Polygon -1 true false 213 212 225 222 270 222 251 212
Polygon -1 true false 226 224 268 223 268 239 226 238
Polygon -1 true false 213 214 214 238 225 238 224 224
Line -16777216 false 212 223 225 234
Line -16777216 false 213 235 220 239
Line -16777216 false 226 233 268 233
Polygon -1184463 true false 232 213 221 216 245 221
Circle -2674135 false false 230 214 6
Circle -2674135 false false 238 215 4
Polygon -1184463 true false 179 230 168 233 192 238
Circle -2674135 false false 176 231 6
Circle -2674135 false false 183 233 4
Polygon -1184463 true false 236 224 225 227 249 232
Polygon -1184463 true false 238 234 227 237 247 240
Circle -2674135 false false 228 234 6
Circle -2674135 false false 229 225 6
Circle -2674135 false false 238 234 4
Circle -2674135 false false 235 227 4
Polygon -13840069 true false 258 225 259 223 264 227 263 231 261 232 259 232 255 229 256 224 260 227
Polygon -13840069 true false 249 215 250 213 255 217 254 221 252 222 250 222 246 219 247 214 251 217
Polygon -13840069 true false 192 231 193 229 198 233 197 237 195 238 193 238 189 235 190 230 194 233
Polygon -1 false false 162 189 181 235 279 234 222 189
Line -1 false 202 193 187 227
Line -1 false 207 202 192 236
Circle -1 false false 206 218 16

middle freezer green
false
0
Polygon -1 true false 0 225 0 285 45 300 300 300 300 240 255 225
Polygon -16777216 true false 0 270 45 285 45 300 0 285 0 270
Rectangle -16777216 true false 45 285 300 300
Rectangle -16777216 true false 0 225 9 285
Polygon -14835848 true false 45 240 0 225 255 225 300 240
Rectangle -16777216 true false 45 240 300 245
Rectangle -16777216 true false 45 285 300 290
Polygon -16777216 true false 1 271 45 285 45 290 1 276 1 272 1 272
Polygon -16777216 true false 1 226 45 240 45 245 1 231 1 227 1 227
Rectangle -16777216 true false 45 240 54 300
Rectangle -16777216 true false 285 240 300 300
Rectangle -16777216 true false 165 240 174 300
Rectangle -16777216 true false 248 225 255 244
Rectangle -16777216 true false 1 225 8 244
Polygon -1 false false 300 240 225 180 255 225
Line -1 false 75 180 225 180
Polygon -16777216 true false 133 226 133 226 163 241 178 241 148 226
Line -1 false 151 180 176 241
Polygon -1 false false 0 225 45 240 300 240 255 225
Polygon -1 false false 83 225
Line -1 false 152 182 132 224
Rectangle -1 true false 75 165 225 180
Rectangle -7500403 false true 75 165 225 180
Polygon -13791810 false false 61 267 61 276 70 278 71 270
Polygon -13791810 false false 56 253 61 262 71 258 67 250
Polygon -13791810 false false 78 261 76 271 89 274 89 261
Polygon -10899396 true false 91 228 97 220 95 216 135 216 133 218 137 228 138 233 104 234
Polygon -1184463 true false 42 227 43 236 46 236 46 226
Polygon -13840069 true false 99 231 105 223 103 219 143 219 141 221 145 231 146 236 112 237
Polygon -14835848 true false 104 239 110 231 108 227 148 227 146 229 151 237 152 239 118 239
Polygon -14835848 true false 51 226 57 218 55 214 95 214 93 216 97 226 98 231 64 232
Polygon -10899396 true false 55 230 61 222 59 218 99 218 97 220 102 228 102 234 70 235
Polygon -13840069 true false 63 235 69 227 67 223 107 223 105 225 109 235 110 240 76 241
Polygon -13840069 true false 9 226 15 218 13 214 53 214 51 216 55 226 56 231 22 232
Polygon -14835848 true false 20 231 26 223 24 219 64 219 62 221 66 231 67 236 33 237
Polygon -10899396 true false 31 236 37 228 35 224 75 224 73 226 78 234 78 240 46 241
Polygon -1184463 true false 39 227 43 236 46 235 43 229
Polygon -955883 true false 46 230 50 239 53 239 50 229
Polygon -2674135 true false 57 229 56 240 58 241 62 228
Polygon -955883 true false 64 229 64 240 68 239 69 230
Polygon -1184463 true false 77 227 81 236 84 235 81 229
Polygon -955883 true false 83 226 87 235 90 235 87 225
Polygon -2674135 true false 92 227 91 238 93 239 97 226
Polygon -955883 true false 97 228 97 239 101 238 102 229
Polygon -1184463 true false 110 229 114 238 117 237 114 231
Polygon -955883 true false 115 227 119 236 122 236 119 226
Polygon -2674135 true false 124 228 123 239 125 240 129 227
Polygon -955883 true false 130 230 130 241 134 240 135 231
Polygon -1 false false 81 187 59 236 165 235 147 187
Polygon -1 false false 0 225 75 180 45 240
Line -1 false 98 190 83 224
Line -1 false 103 202 88 236
Circle -1 false false 101 216 16
Polygon -1 true false 158 230 203 230 212 239 176 239
Polygon -1 true false 213 212 225 222 270 222 251 212
Polygon -1 true false 226 224 268 223 268 239 226 238
Polygon -1 true false 213 214 214 238 225 238 224 224
Line -16777216 false 213 235 220 239
Polygon -13840069 true false 232 213 221 216 245 221
Circle -2674135 false false 230 214 6
Circle -2674135 false false 238 215 4
Polygon -13840069 true false 179 230 168 233 192 238
Circle -2674135 false false 176 231 6
Circle -2674135 false false 183 233 4
Polygon -10899396 true false 239 230 240 228 245 232 244 236 242 237 240 237 236 234 237 229 241 232
Polygon -6459832 true false 192 231 193 229 198 233 197 237 195 238 193 238 189 235 190 230 194 233
Line -1 false 202 193 187 227
Line -1 false 207 202 192 236
Circle -1 false false 206 218 16
Polygon -6459832 true false 233 228 234 226 239 230 238 234 236 235 234 235 230 232 231 227 235 230
Polygon -6459832 true false 242 227 243 225 248 229 247 233 245 234 243 234 239 231 240 226 244 229
Polygon -10899396 true false 253 214 254 212 259 216 258 220 256 221 254 221 250 218 251 213 255 216
Polygon -6459832 true false 248 214 249 212 254 216 253 220 251 221 249 221 245 218 246 213 250 216
Polygon -10899396 true false 198 231 199 229 204 233 203 237 201 238 199 238 195 235 196 230 200 233
Rectangle -16777216 false false 253 227 265 235
Polygon -1 false false 162 189 181 235 279 234 222 189

middle shelf 1
false
0
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 45 181 54 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 0 195 45 180 255 180 300 195
Rectangle -16777216 true false 0 195 300 200
Rectangle -1 true false 36 195 54 200
Rectangle -1 true false 93 195 111 200
Rectangle -1 true false 177 195 195 200
Polygon -6459832 true false 0 240 45 225 255 225 300 240
Polygon -6459832 true false 0 285 45 270 255 270 300 285
Rectangle -16777216 true false 0 285 300 290
Rectangle -16777216 true false 0 240 300 245
Rectangle -1 true false 36 240 54 245
Rectangle -1 true false 93 240 111 245
Rectangle -1 true false 222 240 240 245
Rectangle -1 true false 36 285 54 290
Rectangle -1 true false 93 285 111 290
Rectangle -1 true false 222 285 240 290
Rectangle -16777216 true false 0 196 9 300
Rectangle -16777216 true false 291 196 300 300
Rectangle -16777216 true false 150 196 159 300
Rectangle -1 true false 222 195 240 200
Rectangle -1 true false 177 240 195 245
Rectangle -1 true false 177 285 195 290

middle shelf 2
false
0
Polygon -16777216 true false 0 270 45 285 45 300 0 285 0 270
Rectangle -16777216 true false 45 285 300 300
Rectangle -16777216 true false 121 181 130 285
Rectangle -16777216 true false 0 181 9 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 45 195 0 180 255 180 300 195
Rectangle -16777216 true false 45 195 300 200
Polygon -16777216 true false 1 181 45 195 45 200 1 186 1 182 1 182
Polygon -6459832 true false 45 240 0 225 255 225 300 240
Polygon -6459832 true false 45 285 0 270 255 270 300 285
Rectangle -1 true false 66 195 84 200
Rectangle -1 true false 108 195 126 200
Rectangle -1 true false 192 195 210 200
Rectangle -16777216 true false 45 240 300 245
Rectangle -1 true false 66 240 84 245
Rectangle -1 true false 108 240 126 245
Rectangle -1 true false 192 240 210 245
Rectangle -16777216 true false 45 285 300 290
Rectangle -1 true false 66 285 84 290
Rectangle -1 true false 108 285 126 290
Rectangle -1 true false 192 285 210 290
Polygon -16777216 true false 1 271 45 285 45 290 1 276 1 272 1 272
Polygon -16777216 true false 1 226 45 240 45 245 1 231 1 227 1 227
Rectangle -16777216 true false 45 196 54 300
Rectangle -16777216 true false 291 196 300 300
Rectangle -16777216 true false 165 196 174 300
Rectangle -1 true false 237 285 255 290
Rectangle -1 true false 237 240 255 245
Rectangle -1 true false 237 195 255 200

mystery freezer
false
0
Polygon -1 true false 0 225 0 285 45 300 300 300 300 240 255 225
Polygon -14835848 true false 45 240 0 225 255 225 300 240
Polygon -1 false false 0 225 45 240 300 240 255 225
Polygon -16777216 true false 0 270 45 285 45 300 0 285 0 270
Rectangle -16777216 true false 45 285 300 300
Rectangle -16777216 true false 0 225 9 285
Rectangle -16777216 true false 45 240 300 245
Rectangle -16777216 true false 45 285 300 290
Polygon -16777216 true false 1 271 45 285 45 290 1 276 1 272 1 272
Polygon -16777216 true false 1 226 45 240 45 245 1 231 1 227 1 227
Rectangle -16777216 true false 45 240 54 300
Rectangle -16777216 true false 285 240 300 300
Rectangle -16777216 true false 165 240 174 300
Rectangle -16777216 true false 248 225 255 244
Rectangle -16777216 true false 1 225 8 244
Polygon -1 false false 300 240 225 180 255 225
Line -1 false 75 180 225 180
Polygon -16777216 true false 133 226 133 226 163 241 178 241 148 226
Polygon -1 false false 83 225
Line -1 false 152 182 132 224
Rectangle -1 true false 75 165 225 180
Rectangle -7500403 false true 75 165 225 180
Polygon -5825686 true false 68 240 81 235 82 230 85 224 84 221 77 219 72 218 71 212 74 204 81 201 88 201 92 198 94 192 98 195 96 201 94 204 87 206 84 209 86 214 92 215 95 218 99 226 99 236 99 240
Circle -1184463 true false 88 217 8
Circle -13840069 true false 87 202 4
Circle -13840069 true false 80 211 6
Circle -13840069 true false 90 230 8
Circle -1184463 true false 79 205 4
Circle -1184463 true false 92 197 4
Line -1 false 105 192 90 226
Line -1 false 109 201 94 235
Polygon -5825686 true false 131 240 136 234 139 229 139 225 138 220 131 217 127 218 121 221 115 221 111 215 113 212 115 210 115 208 111 208 108 212 106 215 108 223 114 228 119 228 129 224 130 230 125 234 116 236 111 240 116 241
Circle -1 false false 100 214 16
Circle -13840069 true false 128 220 4
Circle -13840069 true false 123 233 6
Circle -1184463 true false 131 226 6
Circle -1184463 true false 121 221 4
Circle -13840069 true false 112 221 4
Circle -1184463 true false 106 215 4
Circle -13840069 true false 112 209 2
Polygon -5825686 true false 63 240 62 234 60 231 58 229 51 228 49 228 46 224 47 221 52 217 52 213 49 210 42 207 38 208 35 212 37 215 41 212 47 217 46 216 45 215 40 220 39 225 42 230 46 235 50 235 50 240
Circle -13840069 true false 50 233 6
Circle -1184463 true false 43 228 6
Circle -13840069 true false 37 221 6
Circle -1184463 true false 43 215 4
Circle -13840069 true false 41 209 4
Circle -1184463 true false 36 210 2
Polygon -1 false false 0 225 75 180 45 240
Polygon -955883 true false 231 234 234 229 238 224 235 219 233 217 233 212 239 213 241 219 244 214 249 212 250 217 244 223 245 227 247 234
Polygon -955883 true false 195 231 198 226 202 221 199 216 197 214 197 209 203 210 205 216 208 211 213 209 214 214 208 220 209 224 211 231
Polygon -955883 true false 160 233 163 228 167 223 164 218 162 216 162 211 168 212 170 218 173 213 178 211 179 216 173 222 174 226 176 233
Polygon -1 true false 177 233 180 238 185 236 183 231
Polygon -1 true false 248 232 247 238 252 240 258 237 255 232
Polygon -1 true false 254 228 251 233 247 230 248 227 252 223
Polygon -1 true false 256 231 255 237 260 239 266 236 263 231
Polygon -1 true false 227 228 226 234 231 236 237 233 234 228
Polygon -1 true false 213 224 212 230 217 232 223 229 220 224
Polygon -1 true false 194 228 193 234 198 236 204 233 201 228
Polygon -1 true false 183 227 182 233 187 235 193 232 190 227
Polygon -1 true false 171 230 170 236 175 238 181 235 178 230
Polygon -1 true false 247 233 244 238 240 235 241 232 245 228
Polygon -1 true false 230 235 227 240 223 237 224 234 228 230
Polygon -1 true false 273 234 270 239 266 236 267 233 271 229
Polygon -1 true false 250 235 247 240 243 237 244 234 248 230
Polygon -1 true false 214 226 211 231 207 228 208 225 212 221
Polygon -1 true false 172 230 169 235 165 232 166 229 170 225
Polygon -1 true false 218 229 221 234 226 232 224 227
Polygon -1 true false 236 234 239 239 244 237 242 232
Polygon -1 true false 212 235 215 240 220 238 218 233
Polygon -1 true false 173 225 176 230 181 228 179 223
Polygon -1 true false 202 233 205 238 210 236 208 231
Polygon -1 true false 187 234 190 239 195 237 193 232
Polygon -955883 true false 179 240 182 235 186 230 183 225 181 223 181 218 187 219 189 225 192 220 197 218 198 223 192 229 193 233 195 240
Polygon -955883 true false 213 240 216 235 220 230 217 225 215 223 215 218 221 219 223 225 226 220 231 218 232 223 226 229 227 233 229 240
Polygon -955883 true false 249 240 252 235 256 230 253 225 251 223 251 218 257 219 259 225 262 220 267 218 268 223 262 229 263 233 265 240
Line -1 false 151 180 176 241
Polygon -1 false false 79 186 57 235 163 234 145 186
Polygon -1 false false 162 187 181 233 279 232 222 187
Circle -1 false false 205 211 16
Line -1 false 200 191 185 225
Line -1 false 206 200 191 234
Polygon -13791810 false false 75 264 78 276 91 271 87 259
Polygon -13791810 false false 62 251 56 260 65 267 72 255
Polygon -13791810 false false 61 269 59 276 66 278 69 270

nonperishable shelf
false
0
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 45 181 54 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 0 195 45 180 255 180 300 195
Rectangle -16777216 true false 0 195 300 200
Rectangle -1 true false 16 195 34 200
Rectangle -1 true false 43 195 61 200
Rectangle -1 true false 177 195 195 200
Polygon -6459832 true false 0 240 45 225 255 225 300 240
Polygon -6459832 true false 0 285 45 270 255 270 300 285
Rectangle -16777216 true false 0 285 300 290
Rectangle -16777216 true false 0 241 300 246
Rectangle -1 true false 12 240 30 245
Rectangle -1 true false 42 240 60 245
Rectangle -1 true false 222 240 240 245
Rectangle -1 true false 21 285 39 290
Rectangle -1 true false 63 285 81 290
Rectangle -1 true false 222 285 240 290
Rectangle -16777216 true false 0 196 9 300
Rectangle -16777216 true false 291 196 300 300
Rectangle -16777216 true false 150 196 159 300
Rectangle -1 true false 222 195 240 200
Rectangle -1 true false 177 285 195 290
Rectangle -13345367 true false 41 214 56 229
Rectangle -13345367 true false 41 214 56 229
Rectangle -13345367 true false 31 217 46 232
Rectangle -13345367 true false 19 222 34 237
Polygon -16777216 true false 19 222 21 220 24 219 28 219 32 221 29 224 25 225 23 225
Polygon -16777216 true false 41 214 43 212 46 211 50 211 54 213 51 216 47 217 45 217
Polygon -16777216 true false 29 218 31 216 34 215 38 215 42 217 39 220 35 221 33 221
Rectangle -14835848 true false 62 213 77 228
Rectangle -14835848 true false 53 219 68 234
Rectangle -14835848 true false 44 224 59 239
Polygon -16777216 true false 45 226 47 224 50 223 54 223 58 225 55 228 51 229 49 229
Polygon -16777216 true false 54 220 56 218 59 217 63 217 67 219 64 222 60 223 58 223
Polygon -16777216 true false 63 214 65 212 68 211 72 211 76 213 73 216 69 217 67 217
Rectangle -13345367 true false 48 169 63 184
Rectangle -13345367 true false 37 173 52 188
Rectangle -13345367 true false 24 178 39 193
Polygon -16777216 true false 49 170 51 168 54 167 58 167 62 169 59 172 55 173 53 173
Polygon -16777216 true false 38 173 40 171 43 170 47 170 51 172 48 175 44 176 42 176
Polygon -16777216 true false 24 179 26 177 29 176 33 176 37 178 34 181 30 182 28 182
Rectangle -14835848 true false 66 169 81 184
Rectangle -14835848 true false 59 172 74 187
Rectangle -14835848 true false 51 177 66 192
Polygon -16777216 true false 68 170 70 168 73 167 77 167 81 169 78 172 74 173 72 173
Polygon -16777216 true false 59 174 61 172 64 171 68 171 72 173 69 176 65 177 63 177
Polygon -16777216 true false 50 179 52 177 55 176 59 176 63 178 60 181 56 182 54 182
Circle -2674135 true false 25 183 8
Circle -2674135 true false 32 222 8
Circle -2674135 true false 20 226 8
Circle -2674135 true false 40 177 8
Polygon -13840069 true false 51 181 59 191 62 192 63 188 57 181 54 179
Polygon -13840069 true false 43 228 51 238 54 239 55 235 49 228 46 226
Polygon -13840069 true false 54 222 62 232 65 233 66 229 60 222 57 220
Polygon -13840069 true false 60 175 68 185 71 186 72 182 66 175 63 173
Rectangle -2064490 true false 84 169 99 184
Polygon -16777216 true false 85 169 87 167 90 166 94 166 98 168 95 171 91 172 89 172
Rectangle -2064490 true false 75 173 90 188
Polygon -16777216 true false 76 174 78 172 81 171 85 171 89 173 86 176 82 177 80 177
Circle -10899396 true false 79 182 4
Circle -10899396 true false 82 179 4
Circle -10899396 true false 77 179 4
Circle -10899396 true false 92 180 4
Circle -10899396 true false 91 174 4
Circle -955883 true false 68 185 6
Circle -955883 true false 90 174 6
Circle -955883 true false 79 183 6
Rectangle -2064490 true false 68 177 83 192
Polygon -16777216 true false 68 179 70 177 73 176 77 176 81 178 78 181 74 182 72 182
Circle -10899396 true false 77 183 4
Circle -10899396 true false 74 186 4
Circle -10899396 true false 70 183 4
Circle -955883 true false 70 186 6
Rectangle -2064490 true false 106 169 121 184
Polygon -16777216 true false 107 170 109 168 112 167 116 167 120 169 117 172 113 173 111 173
Circle -10899396 true false 110 178 4
Circle -10899396 true false 108 175 4
Circle -10899396 true false 115 172 4
Circle -955883 true false 112 176 6
Rectangle -1 true false 70 195 88 200
Rectangle -2064490 true false 98 174 113 189
Polygon -16777216 true false 99 174 101 172 104 171 108 171 112 173 109 176 105 177 103 177
Circle -10899396 true false 106 183 4
Circle -10899396 true false 99 177 4
Circle -955883 true false 104 178 6
Rectangle -2064490 true false 88 180 103 195
Polygon -16777216 true false 89 182 91 180 94 179 98 179 102 181 99 184 95 185 93 185
Circle -10899396 true false 98 183 4
Circle -10899396 true false 94 191 4
Circle -10899396 true false 90 188 4
Circle -955883 true false 96 185 6
Rectangle -16777216 true false 83 214 98 229
Polygon -6459832 true false 83 215 85 213 88 212 92 212 96 214 93 217 89 218 87 218
Circle -1184463 true false 99 235 4
Circle -1184463 true false 88 224 4
Circle -1184463 true false 92 219 4
Rectangle -16777216 true false 76 220 91 235
Polygon -6459832 true false 76 221 78 219 81 218 85 218 89 220 86 223 82 224 80 224
Circle -1184463 true false 77 226 4
Circle -1184463 true false 82 224 4
Circle -1184463 true false 86 227 4
Circle -1184463 true false 81 230 4
Rectangle -16777216 true false 67 224 82 239
Polygon -6459832 true false 68 225 70 223 73 222 77 222 81 224 78 227 74 228 72 228
Circle -1184463 true false 68 235 4
Circle -1184463 true false 76 228 4
Circle -1184463 true false 72 231 4
Circle -1184463 true false 68 227 4
Circle -1184463 true false 77 234 4
Rectangle -16777216 true false 102 214 117 229
Polygon -6459832 true false 103 215 105 213 109 212 112 212 116 214 113 217 109 218 107 218
Circle -1184463 true false 112 224 4
Circle -1184463 true false 113 217 4
Circle -1184463 true false 109 220 4
Circle -1184463 true false 104 224 4
Circle -1184463 true false 105 217 4
Rectangle -16777216 true false 95 219 110 234
Polygon -6459832 true false 95 221 97 219 101 218 104 218 108 220 105 223 101 224 99 224
Circle -1184463 true false 102 223 4
Circle -1184463 true false 103 229 4
Circle -1184463 true false 97 226 4
Rectangle -16777216 true false 88 225 103 240
Polygon -6459832 true false 90 228 92 226 95 225 99 225 103 227 100 230 96 231 94 231
Circle -1184463 true false 90 236 4
Circle -1184463 true false 95 235 4
Circle -1184463 true false 97 230 4
Circle -1184463 true false 91 232 4
Rectangle -13345367 true false 121 214 136 229
Polygon -16777216 true false 122 215 124 213 128 212 131 212 135 214 132 217 128 218 126 218
Circle -2674135 true false 124 219 8
Rectangle -13345367 true false 113 219 128 234
Polygon -16777216 true false 114 219 116 217 120 216 123 216 127 218 124 221 120 222 118 222
Circle -2674135 true false 115 223 8
Rectangle -1 true false 68 240 86 245
Rectangle -1 true false 113 239 131 244
Rectangle -13345367 true false 105 224 120 239
Polygon -16777216 true false 106 225 108 223 112 222 115 222 119 224 116 227 112 228 110 228
Circle -2674135 true false 107 230 8
Rectangle -13345367 true false 139 213 154 228
Polygon -16777216 true false 140 213 142 211 145 210 149 210 153 212 150 215 146 216 144 216
Circle -2674135 true false 142 217 8
Rectangle -13345367 true false 133 218 148 233
Polygon -16777216 true false 133 220 135 218 138 217 142 217 146 219 143 222 139 223 137 223
Circle -2674135 true false 135 224 8
Rectangle -13345367 true false 125 223 140 238
Polygon -16777216 true false 126 224 128 222 132 221 135 221 139 223 136 226 132 227 130 227
Circle -2674135 true false 128 229 8
Polygon -2674135 true false 125 183 125 163 129 158 129 154 137 153 137 158 141 163 141 183
Polygon -1184463 true false 156 187 156 167 160 162 160 158 168 157 168 162 172 167 172 187
Polygon -1 true false 238 156 238 159 234 163 233 175 236 182 252 184 255 176 255 163 252 159 252 157
Polygon -14835848 true false 233 164 255 165 255 176 233 176
Polygon -1184463 true false 166 203 166 206 162 210 161 222 164 229 180 231 183 223 183 210 180 206 180 204
Polygon -1 true false 125 168 141 168 141 175 125 174
Circle -2674135 true false 130 168 6
Polygon -2674135 true false 116 191 116 171 120 166 120 162 128 161 128 166 132 171 132 191
Polygon -1 true false 116 175 132 175 132 182 116 181
Circle -2674135 true false 121 176 6
Polygon -16777216 true false 156 172 172 172 172 179 156 178
Polygon -2674135 true false 147 191 147 171 151 166 151 162 159 161 159 166 163 171 163 191
Polygon -1 true false 147 177 163 177 163 184 147 183
Circle -2674135 true false 152 177 6
Rectangle -1 true false 129 195 147 200
Polygon -16777216 false false 237 157 237 159 232 164 233 175 234 181 251 184 255 176 254 163 251 160 252 158
Polygon -1 true false 212 158 212 161 208 165 207 177 210 184 226 186 229 178 229 165 226 161 226 159
Polygon -14835848 true false 207 166 229 167 229 178 207 178
Polygon -16777216 false false 211 159 211 161 206 166 207 177 208 183 225 186 229 178 228 165 225 162 226 160
Polygon -1 true false 186 157 186 160 182 164 181 176 184 183 200 185 203 177 203 164 200 160 200 158
Polygon -14835848 true false 181 165 203 166 203 177 181 177
Polygon -16777216 false false 185 158 185 160 180 165 181 176 182 182 199 185 203 177 202 164 199 161 200 159
Polygon -1 true false 255 163 255 166 251 170 250 182 253 189 269 191 272 183 272 170 269 166 269 164
Polygon -14835848 true false 251 172 273 173 273 184 251 184
Polygon -16777216 false false 255 164 255 166 250 171 251 182 252 188 269 191 273 183 272 170 269 167 270 165
Polygon -1 true false 229 162 229 165 225 169 224 181 227 188 243 190 246 182 246 169 243 165 243 163
Polygon -14835848 true false 225 171 247 172 247 183 225 183
Polygon -16777216 false false 229 163 229 165 224 170 225 181 226 187 243 190 247 182 246 169 243 166 244 164
Polygon -1 true false 202 163 202 166 198 170 197 182 200 189 216 191 219 183 219 170 216 166 216 164
Polygon -14835848 true false 197 172 219 173 219 184 197 184
Polygon -16777216 false false 201 164 201 166 196 171 197 182 198 188 215 191 219 183 218 170 215 167 216 165
Polygon -1184463 true false 175 189 175 169 179 164 179 160 187 159 187 164 191 169 191 189
Polygon -16777216 true false 175 175 191 175 191 182 175 181
Polygon -955883 true false 161 212 183 213 183 224 161 224
Polygon -16777216 false false 165 204 165 206 160 211 161 222 162 228 179 231 183 223 182 210 179 207 180 205
Polygon -1184463 true false 191 203 191 206 187 210 186 222 189 229 205 231 208 223 208 210 205 206 205 204
Polygon -955883 true false 187 212 209 213 209 224 187 224
Polygon -16777216 false false 190 204 190 206 185 211 186 222 187 228 204 231 208 223 207 210 204 207 205 205
Polygon -1184463 true false 217 203 217 206 213 210 212 222 215 229 231 231 234 223 234 210 231 206 231 204
Polygon -955883 true false 212 212 234 213 234 224 212 224
Polygon -16777216 false false 216 205 216 207 211 212 212 223 213 229 230 232 234 224 233 211 230 208 231 206
Polygon -1184463 true false 244 201 244 204 240 208 239 220 242 227 258 229 261 221 261 208 258 204 258 202
Polygon -955883 true false 239 210 261 211 261 222 239 222
Polygon -16777216 false false 244 202 244 204 239 209 240 220 241 226 258 229 262 221 261 208 258 205 259 203
Polygon -1184463 true false 179 209 179 212 175 216 174 228 177 235 193 237 196 229 196 216 193 212 193 210
Polygon -955883 true false 174 219 196 220 196 231 174 231
Polygon -16777216 false false 178 210 178 212 173 217 174 228 175 234 192 237 196 229 195 216 192 213 193 211
Polygon -1184463 true false 206 209 206 212 202 216 201 228 204 235 220 237 223 229 223 216 220 212 220 210
Polygon -955883 true false 202 219 224 220 224 231 202 231
Polygon -16777216 false false 205 211 205 213 200 218 201 229 202 235 219 238 223 230 222 217 219 214 220 212
Polygon -1184463 true false 234 208 234 211 230 215 229 227 232 234 248 236 251 228 251 215 248 211 248 209
Polygon -955883 true false 229 218 251 219 251 230 229 230
Polygon -16777216 false false 233 210 233 212 228 217 229 228 230 234 247 237 251 229 250 216 247 213 248 211
Polygon -1184463 true false 264 207 264 210 260 214 259 226 262 233 278 235 281 227 281 214 278 210 278 208
Polygon -955883 true false 259 216 281 217 281 228 259 228
Polygon -16777216 false false 264 209 264 211 259 216 260 227 261 233 278 236 282 228 281 215 278 212 279 210
Circle -16777216 true false 182 223 4
Circle -1184463 true false 184 223 4
Circle -16777216 true false 186 223 4
Circle -16777216 true false 207 223 4
Circle -1184463 true false 209 222 4
Circle -16777216 true false 211 222 4
Circle -16777216 true false 264 220 4
Circle -16777216 true false 234 222 4
Circle -1184463 true false 266 219 4
Circle -1184463 true false 237 222 4
Circle -16777216 true false 268 218 4
Circle -16777216 true false 239 222 4
Polygon -1 true false 167 250 167 253 163 257 162 269 165 276 181 278 184 270 184 257 181 253 181 251
Polygon -10899396 true false 169 256 166 258 166 263 166 271 170 274 173 272 173 266 172 257
Polygon -10899396 true false 177 257 174 265 174 267 176 271 180 269 182 261 181 257
Polygon -16777216 true false 163 259 185 260 184 266 163 265
Polygon -16777216 false false 166 251 166 253 161 258 162 269 163 275 180 278 184 270 183 257 180 254 181 252
Polygon -1 true false 194 250 194 253 190 257 189 269 192 276 208 278 211 270 211 257 208 253 208 251
Polygon -10899396 true false 195 256 192 258 192 263 192 271 196 274 199 272 199 266 198 257
Polygon -10899396 true false 203 260 200 268 200 270 202 274 206 272 208 264 207 260
Polygon -16777216 true false 189 261 211 262 210 268 189 267
Polygon -16777216 false false 193 251 193 253 188 258 189 269 190 275 207 278 211 270 210 257 207 254 208 252
Polygon -1 true false 181 256 181 259 177 263 176 275 179 282 195 284 198 276 198 263 195 259 195 257
Polygon -10899396 true false 183 262 180 264 180 269 180 277 184 280 187 278 187 272 186 263
Polygon -10899396 true false 192 264 189 272 189 274 191 278 195 276 197 268 196 264
Polygon -16777216 true false 177 268 199 269 198 275 177 274
Polygon -16777216 false false 180 257 180 259 175 264 176 275 177 281 194 284 198 276 197 263 194 260 195 258
Polygon -1 true false 223 250 223 253 219 257 218 269 221 276 237 278 240 270 240 257 237 253 237 251
Polygon -1 true false 249 251 249 254 245 258 244 270 247 277 263 279 266 271 266 258 263 254 263 252
Circle -8630108 true false 219 255 8
Circle -8630108 true false 252 262 8
Circle -8630108 true false 257 255 8
Circle -8630108 true false 248 255 8
Circle -8630108 true false 229 269 8
Circle -8630108 true false 227 251 8
Circle -8630108 true false 221 266 8
Circle -8630108 true false 230 260 8
Circle -8630108 true false 257 270 8
Circle -8630108 true false 245 266 8
Polygon -16777216 true false 218 261 240 262 239 268 218 267
Polygon -16777216 true false 244 262 266 263 265 269 244 268
Polygon -16777216 false false 249 252 249 254 244 259 245 270 246 276 263 279 267 271 266 258 263 255 264 253
Polygon -16777216 false false 223 251 223 253 218 258 219 269 220 275 237 278 241 270 240 257 237 254 238 252
Polygon -1 true false 237 256 237 259 233 263 232 275 235 282 251 284 254 276 254 263 251 259 251 257
Circle -8630108 true false 235 262 8
Circle -8630108 true false 241 258 8
Circle -8630108 true false 245 265 8
Circle -8630108 true false 244 275 8
Circle -8630108 true false 238 271 8
Polygon -16777216 false false 236 257 236 259 231 264 232 275 233 281 250 284 254 276 253 263 250 260 251 258
Polygon -16777216 true false 233 266 255 267 254 273 233 272
Polygon -16777216 true false 38 261 38 261 38 261 39 267 35 267 35 275 51 276 51 267 48 267 50 261
Polygon -16777216 true false 38 261 38 261 38 261 39 267 35 267 35 275 51 276 51 267 48 267 50 261
Polygon -16777216 true false 58 262 58 262 58 262 59 268 55 268 55 276 71 277 71 268 68 268 70 262
Polygon -16777216 true false 78 261 78 261 78 261 79 267 75 267 75 275 91 276 91 267 88 267 90 261
Polygon -16777216 true false 98 261 98 261 98 261 99 267 95 267 95 275 111 276 111 267 108 267 110 261
Polygon -16777216 true false 118 261 118 261 118 261 119 267 115 267 115 275 131 276 131 267 128 267 130 261
Polygon -16777216 true false 136 260 136 260 136 260 137 266 133 266 133 274 149 275 149 266 146 266 148 260
Polygon -5825686 false false 38 261 39 265 35 264 35 274 49 274 49 265 47 264 47 261
Polygon -5825686 false false 59 262 60 266 56 265 56 275 70 275 70 266 68 265 68 262
Polygon -2674135 false false 79 262 80 266 76 265 76 275 90 275 90 266 88 265 88 262
Polygon -2674135 false false 98 262 99 266 95 265 95 275 109 275 109 266 107 265 107 262
Polygon -955883 false false 118 262 119 266 115 265 115 275 129 275 129 266 127 265 127 262
Polygon -955883 false false 137 261 138 265 134 264 134 274 148 274 148 265 146 264 146 261
Circle -5825686 true false 39 266 7
Circle -5825686 true false 60 266 7
Circle -955883 true false 138 265 7
Circle -955883 true false 119 266 7
Circle -2674135 true false 99 266 7
Circle -2674135 true false 80 266 7
Polygon -16777216 true false 24 266 24 266 24 266 25 272 21 272 21 280 37 281 37 272 34 272 36 266
Polygon -16777216 true false 127 267 127 267 127 267 128 273 124 273 124 281 140 282 140 273 137 273 139 267
Polygon -16777216 true false 107 267 107 267 107 267 108 273 104 273 104 281 120 282 120 273 117 273 119 267
Polygon -16777216 true false 88 270 88 270 88 270 89 276 85 276 85 284 101 285 101 276 98 276 100 270
Polygon -16777216 true false 68 269 68 269 68 269 69 275 65 275 65 283 81 284 81 275 78 275 80 269
Polygon -16777216 true false 44 268 44 268 44 268 45 274 41 274 41 282 57 283 57 274 54 274 56 268
Polygon -5825686 false false 25 267 26 271 22 270 22 280 36 280 36 271 34 270 34 267
Polygon -955883 false false 128 269 129 273 125 272 125 282 139 282 139 273 137 272 137 269
Polygon -955883 false false 107 268 108 272 104 271 104 281 118 281 118 272 116 271 116 268
Polygon -2674135 false false 88 271 89 275 85 274 85 284 99 284 99 275 97 274 97 271
Polygon -2674135 false false 68 269 69 273 65 272 65 282 79 282 79 273 77 272 77 269
Polygon -5825686 false false 45 269 46 273 42 272 42 282 56 282 56 273 54 272 54 269
Circle -5825686 true false 26 272 7
Circle -955883 true false 128 274 7
Circle -955883 true false 108 273 7
Circle -2674135 true false 89 275 7
Circle -2674135 true false 68 273 7
Circle -5825686 true false 45 274 7
Rectangle -1 true false 108 285 126 290

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Polygon -6459832 true false 198 197 208 200 225 201 239 197 257 187 268 166 275 181 277 203 273 220 254 237 233 240 203 228 199 216
Polygon -16777216 true false 199 198 204 182 216 171 231 159 253 161 268 167 265 173 249 166 232 164 220 175 213 181 206 199

person service
false
0
Polygon -7500403 true true 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -1 true false 120 90 105 90 60 195 90 210 120 150 120 195 180 195 180 150 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Polygon -1 true false 123 90 149 141 177 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Polygon -2674135 true false 155 91 128 77 128 101
Rectangle -16777216 true false 118 129 141 140
Polygon -2674135 true false 145 91 172 77 172 101

pincushion orange
false
8
Polygon -11221820 true true 93 277 88 273 79 271 78 266 78 260 81 254 80 252 76 243 72 237 73 233 75 225 73 219 74 207 79 203 80 195 87 186 90 179 98 174 105 178 117 172 126 167 133 171 142 170 151 164 165 165 177 172 177 181 186 185 202 193 203 202 212 205 220 218 219 227 219 241 221 252 215 265 203 278 196 284 183 284 176 283 167 281 160 284 144 284 135 285 131 279 120 278 110 281 94 280 91 276
Polygon -14835848 true false 195 253 204 252 214 242 215 231 223 222 231 212 232 205 223 209 215 216 207 234 201 241 192 245 190 254 194 260
Polygon -14835848 true false 94 268 85 267 75 257 74 246 66 237 58 227 57 220 66 224 74 231 82 249 88 256 97 260 99 269 95 275
Polygon -14835848 true false 109 233 100 232 90 222 89 211 81 202 73 192 72 185 81 189 89 196 97 214 103 221 112 225 114 234 110 240
Polygon -14835848 true false 161 255 180 247 182 239 188 231 194 217 199 211 186 215 181 225 172 237 166 245 150 248 144 256 157 257
Polygon -14835848 true false 132 280 113 272 111 264 105 256 99 242 94 236 107 240 112 250 121 262 127 270 143 273 149 281 136 282
Polygon -14835848 true false 81 233 76 221 64 211 61 200 60 188 65 190 73 206 80 219 91 230 94 247 86 239
Polygon -14835848 true false 177 222 182 210 194 200 197 189 198 177 193 179 185 195 178 208 167 219 164 236 172 228
Polygon -14835848 true false 148 241 159 230 162 220 165 203 170 194 163 186 159 196 158 207 152 218 145 223 144 234 138 241 144 244
Polygon -14835848 true false 132 254 121 243 118 233 115 216 110 207 117 199 121 209 122 220 128 231 135 236 136 247 142 254 136 257
Polygon -14835848 true false 187 267 200 265 212 261 221 252 230 241 230 251 225 256 218 268 211 268 201 279 189 275 181 274
Polygon -14835848 true false 153 197 157 190 165 180 172 168 174 151 174 134 168 134 169 141 165 155 161 166 155 184 152 188
Polygon -14835848 true false 104 208 100 201 92 191 85 179 83 162 83 145 89 145 88 152 92 166 96 177 102 195 105 199
Polygon -14835848 true false 172 199 177 188 174 182 180 166 184 146 189 150 188 162 184 181
Polygon -14835848 true false 134 215 126 204 121 184 117 170 117 153 123 155 125 174 130 184 137 203 140 220
Polygon -14835848 true false 138 182 133 174 134 164 132 148 131 139 138 147 140 162
Polygon -14835848 true false 108 194 103 170 101 154 103 140 103 125 108 130 110 151 108 173 113 196
Polygon -14835848 true false 142 201 143 183 148 169 146 159 151 137 151 119 157 122 157 135 155 157 153 170 146 185
Polygon -14835848 true false 151 276 161 261 179 257 187 242 188 255 175 266 165 269
Polygon -14835848 true false 195 235 197 224 207 209 202 196 211 188 215 177 220 189 211 200 213 217 205 228
Polygon -10899396 true false 61 197 50 193 51 199 60 200 67 202 74 193 70 191 65 195
Polygon -10899396 true false 77 224 66 220 67 226 76 227 83 229 90 220 86 218 81 222
Polygon -10899396 true false 71 215 60 211 61 217 70 218 77 220 84 211 80 209 75 213
Polygon -10899396 true false 65 205 54 201 55 207 64 208 71 210 78 201 74 199 69 203
Polygon -10899396 true false 93 241 82 237 83 243 92 244 99 246 106 237 102 235 97 239
Polygon -10899396 true false 85 232 74 228 75 234 84 235 91 237 98 228 94 226 89 230
Polygon -10899396 true false 104 247 93 243 94 249 103 250 110 252 117 243 113 241 108 245
Polygon -10899396 true false 125 239 114 235 115 241 124 242 131 244 138 235 134 233 129 237
Polygon -10899396 true false 122 229 111 225 112 231 121 232 128 234 135 225 131 223 126 227
Polygon -10899396 true false 119 219 108 215 109 221 118 222 125 224 132 215 128 213 123 217
Polygon -10899396 true false 114 266 103 262 104 268 113 269 120 271 127 262 123 260 118 264
Polygon -10899396 true false 109 257 98 253 99 259 108 260 115 262 122 253 118 251 113 255
Polygon -10899396 true false 82 198 71 194 72 200 81 201 88 203 95 194 91 192 86 196
Polygon -10899396 true false 89 166 78 162 79 168 88 169 95 171 102 162 98 160 93 164
Polygon -10899396 true false 87 158 76 154 77 160 86 161 93 163 100 154 96 152 91 156
Polygon -10899396 true false 96 223 85 219 86 225 95 226 102 228 109 219 105 217 100 221
Polygon -10899396 true false 91 214 80 210 81 216 90 217 97 219 104 210 100 208 95 212
Polygon -10899396 true false 86 205 75 201 76 207 85 208 92 210 99 201 95 199 90 203
Polygon -10899396 true false 100 200 89 196 90 202 99 203 106 205 113 196 109 194 104 198
Polygon -10899396 true false 94 188 83 184 84 190 93 191 100 193 107 184 103 182 98 186
Polygon -10899396 true false 91 179 80 175 81 181 90 182 97 184 104 175 100 173 95 177
Polygon -10899396 true false 119 165 108 161 109 167 118 168 125 170 132 161 128 159 123 163
Polygon -10899396 true false 127 206 116 202 117 208 126 209 133 211 140 202 136 200 131 204
Polygon -10899396 true false 125 194 114 190 115 196 124 197 131 199 138 190 134 188 129 192
Polygon -10899396 true false 124 185 113 181 114 187 123 188 130 190 137 181 133 179 128 183
Polygon -10899396 true false 121 176 110 172 111 178 120 179 127 181 134 172 130 170 125 174
Polygon -10899396 true false 134 216 123 212 124 218 133 219 140 221 147 212 143 210 138 214
Polygon -10899396 true false 57 232 64 230 70 219 71 227 69 232 54 237 54 231
Polygon -10899396 true false 91 274 98 272 104 261 105 269 103 274 88 279 88 273
Polygon -10899396 true false 82 267 89 265 95 254 96 262 94 267 79 272 79 266
Polygon -10899396 true false 75 260 82 258 88 247 89 255 87 260 72 265 72 259
Polygon -10899396 true false 70 253 77 251 83 240 84 248 82 253 67 258 67 252
Polygon -10899396 true false 66 246 73 244 79 233 80 241 78 246 63 251 63 245
Polygon -10899396 true false 61 239 68 237 74 226 75 234 73 239 58 244 58 238
Polygon -10899396 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -10899396 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -10899396 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -10899396 true false 101 186 100 191 113 199 120 192 119 187 113 194
Polygon -10899396 true false 95 173 94 178 107 186 114 179 113 174 107 181
Polygon -10899396 true false 96 159 95 164 108 172 115 165 114 160 108 167
Polygon -10899396 true false 96 145 95 150 108 158 115 151 114 146 108 153
Polygon -10899396 true false 125 148 124 153 137 161 144 154 143 149 137 156
Polygon -10899396 true false 163 127 164 132 151 140 144 133 145 128 151 135
Polygon -10899396 true false 126 170 125 175 138 183 145 176 144 171 138 178
Polygon -10899396 true false 126 158 125 163 138 171 145 164 144 159 138 166
Polygon -10899396 true false 123 274 112 270 113 276 122 277 129 279 136 270 132 268 127 272
Polygon -10899396 true false 130 281 137 279 143 268 144 276 142 281 127 286 127 280
Polygon -10899396 true false 100 279 107 277 113 266 114 274 112 279 97 284 97 278
Polygon -10899396 true false 168 275 161 273 155 262 154 270 156 275 171 280 171 274
Polygon -10899396 true false 189 279 182 277 176 266 175 274 177 279 192 284 192 278
Polygon -10899396 true false 191 255 184 253 178 242 177 250 179 255 194 260 194 254
Polygon -10899396 true false 182 261 175 259 169 248 168 256 170 261 185 266 185 260
Polygon -10899396 true false 172 268 165 266 159 255 158 263 160 268 175 273 175 267
Polygon -10899396 true false 232 257 225 255 219 244 218 252 220 257 235 262 235 256
Polygon -10899396 true false 224 265 217 263 211 252 210 260 212 265 227 270 227 264
Polygon -10899396 true false 214 274 207 272 201 261 200 269 202 274 217 279 217 273
Polygon -10899396 true false 202 277 195 275 189 264 188 272 190 277 205 282 205 276
Polygon -10899396 true false 152 261 145 259 139 248 138 256 140 261 155 266 155 260
Polygon -10899396 true false 174 252 167 250 161 239 160 247 162 252 177 257 177 251
Polygon -10899396 true false 161 255 154 253 148 242 147 250 149 255 164 260 164 254
Polygon -10899396 true false 209 251 202 249 196 238 195 246 197 251 212 256 212 250
Polygon -10899396 true false 216 244 209 242 203 231 202 239 204 244 219 249 219 243
Polygon -10899396 true false 146 241 157 237 156 243 147 244 140 246 133 237 137 235 142 239
Polygon -10899396 true false 162 201 173 197 172 203 163 204 156 206 149 197 153 195 158 199
Polygon -10899396 true false 156 212 167 208 166 214 157 215 150 217 143 208 147 206 152 210
Polygon -10899396 true false 153 222 164 218 163 224 154 225 147 227 140 218 144 216 149 220
Polygon -10899396 true false 149 233 160 229 159 235 150 236 143 238 136 229 140 227 145 231
Polygon -10899396 true false 176 242 187 238 186 244 177 245 170 247 163 238 167 236 172 240
Polygon -10899396 true false 214 234 225 230 224 236 215 237 208 239 201 230 205 228 210 232
Polygon -10899396 true false 190 222 201 218 200 224 191 225 184 227 177 218 181 216 186 220
Polygon -10899396 true false 183 232 194 228 193 234 184 235 177 237 170 228 174 226 179 230
Polygon -10899396 true false 208 198 219 194 218 200 209 201 202 203 195 194 199 192 204 196
Polygon -10899396 true false 207 208 218 204 217 210 208 211 201 213 194 204 198 202 203 206
Polygon -10899396 true false 204 219 215 215 214 221 205 222 198 224 191 215 195 213 200 217
Polygon -10899396 true false 221 195 214 193 208 182 207 190 209 195 224 200 224 194
Polygon -10899396 true false 234 217 227 215 221 204 220 212 222 217 237 222 237 216
Polygon -10899396 true false 228 224 221 222 215 211 214 219 216 224 231 229 231 223
Polygon -10899396 true false 167 225 178 221 177 227 168 228 161 230 154 221 158 219 163 223
Polygon -10899396 true false 195 187 206 183 205 189 196 190 189 192 182 183 186 181 191 185
Polygon -10899396 true false 191 196 202 192 201 198 192 199 185 201 178 192 182 190 187 194
Polygon -10899396 true false 185 206 196 202 195 208 186 209 179 211 172 202 176 200 181 204
Polygon -10899396 true false 175 215 186 211 185 217 176 218 169 220 162 211 166 209 171 213
Polygon -10899396 true false 156 173 157 178 144 186 137 179 138 174 144 181
Polygon -10899396 true false 158 161 159 166 146 174 139 167 140 162 146 169
Polygon -10899396 true false 161 148 162 153 149 161 142 154 143 149 149 156
Polygon -10899396 true false 162 137 163 142 150 150 143 143 144 138 150 145
Polygon -10899396 true false 152 195 153 200 140 208 133 201 134 196 140 203
Polygon -10899396 true false 154 185 155 190 142 198 135 191 136 186 142 193
Polygon -10899396 true false 180 142 181 147 168 155 161 148 162 143 168 150
Polygon -10899396 true false 195 158 196 163 183 171 176 164 177 159 183 166
Polygon -10899396 true false 179 152 180 157 167 165 160 158 161 153 167 160
Polygon -10899396 true false 182 174 193 170 192 176 183 177 176 179 169 170 173 168 178 172
Polygon -10899396 true false 163 180 174 176 173 182 164 183 157 185 150 176 154 174 159 178
Polygon -10899396 true false 178 187 189 183 188 189 179 190 172 192 165 183 169 181 174 185
Polygon -10899396 true false 164 169 175 165 174 171 165 172 158 174 151 165 155 163 160 167
Polygon -955883 false false 106 131 106 126 108 122 109 127 110 122 109 131 115 125 105 134 111 133 102 134 102 120 104 129 96 124 99 132 94 129 100 134 95 137
Polygon -955883 false false 116 209 116 204 118 200 119 205 120 200 119 209 125 203 115 212 121 211 112 212 112 198 114 207 106 202 109 210 104 207 110 212 105 215
Polygon -955883 false false 86 151 86 146 88 142 89 147 90 142 89 151 95 145 85 154 91 153 82 154 82 140 84 149 76 144 79 152 74 149 80 154 75 157
Polygon -955883 false false 103 238 103 233 105 229 106 234 107 229 106 238 112 232 102 241 108 240 99 241 99 227 101 236 93 231 96 239 91 236 97 241 92 244
Polygon -955883 false false 79 189 79 184 81 180 82 185 83 180 82 189 88 183 78 192 84 191 75 192 75 178 77 187 69 182 72 190 67 187 73 192 68 195
Polygon -955883 false false 63 189 63 184 65 180 66 185 67 180 66 189 72 183 62 192 68 191 59 192 59 178 61 187 53 182 56 190 51 187 57 192 52 195
Polygon -955883 false false 58 222 58 217 60 213 61 218 62 213 61 222 67 216 57 225 63 224 54 225 54 211 56 220 48 215 51 223 46 220 52 225 47 228
Polygon -955883 false false 131 257 131 252 133 248 134 253 135 248 134 257 140 251 130 260 136 259 127 260 127 246 129 255 121 250 124 258 119 255 125 260 120 263
Polygon -955883 false false 121 155 121 150 123 146 124 151 125 146 124 155 130 149 120 158 126 157 117 158 117 144 119 153 111 148 114 156 109 153 115 158 110 161
Polygon -955883 false false 137 186 137 181 139 177 140 182 141 177 140 186 146 180 136 189 142 188 133 189 133 175 135 184 127 179 130 187 125 184 131 189 126 192
Polygon -13840069 true false 102 243 96 240 94 236 97 231 103 231 108 233 108 241 105 245
Polygon -13840069 true false 130 261 124 258 122 254 125 249 131 249 136 251 136 259 133 263
Polygon -13840069 true false 57 228 51 225 49 221 52 216 58 216 63 218 63 226 60 230
Polygon -1184463 true false 62 193 56 190 54 186 57 181 63 181 68 183 68 191 65 195
Polygon -13840069 true false 79 193 73 190 71 186 74 181 80 181 85 183 85 191 82 195
Polygon -1184463 true false 85 154 79 151 77 147 80 142 86 142 91 144 91 152 88 156
Polygon -13840069 true false 116 212 110 209 108 205 111 200 117 200 122 202 122 210 119 214
Polygon -1184463 true false 105 135 99 132 97 128 100 123 106 123 111 125 111 133 108 137
Polygon -13840069 true false 120 160 114 157 112 153 115 148 121 148 126 150 126 158 123 162
Polygon -13840069 true false 136 190 130 187 128 183 131 178 137 178 142 180 142 188 139 192
Polygon -955883 false false 86 153 78 155 74 147 74 142 80 138 83 136 88 139 90 136 95 144 95 152 92 155 85 154
Polygon -955883 false false 106 133 98 135 94 127 94 122 100 118 103 116 108 119 110 116 115 124 115 132 112 135 105 134
Polygon -955883 false false 168 140 168 135 166 131 166 138 164 131 165 140 159 134 169 143 163 142 172 143 172 129 170 138 178 133 175 141 180 138 174 143 179 146
Polygon -955883 false false 141 217 141 212 139 208 139 215 137 208 138 217 132 211 142 220 136 219 145 220 145 206 143 215 151 210 148 218 153 215 147 220 152 223
Polygon -955883 false false 161 193 161 188 159 184 159 191 157 184 158 193 152 187 162 196 156 195 165 196 165 182 163 191 171 186 168 194 173 191 167 196 172 199
Polygon -955883 false false 132 145 132 140 130 136 130 143 128 136 129 145 123 139 133 148 127 147 136 148 136 134 134 143 142 138 139 146 144 143 138 148 143 151
Polygon -955883 false false 150 123 150 118 148 114 148 121 146 114 147 123 141 117 151 126 145 125 154 126 154 112 152 121 160 116 157 124 162 121 156 126 161 129
Polygon -1184463 true false 154 127 148 124 146 120 149 115 155 115 160 117 160 125 157 129
Polygon -13840069 true false 136 148 130 145 128 141 131 136 137 136 142 138 142 146 139 150
Polygon -13840069 true false 165 196 159 193 157 189 160 184 166 184 171 186 171 194 168 198
Polygon -13840069 true false 146 220 140 217 138 213 141 208 147 208 152 210 152 218 149 222
Polygon -1184463 true false 172 143 166 140 164 136 167 131 173 131 178 133 178 141 175 145
Polygon -955883 false false 152 126 160 128 164 120 164 115 158 111 155 109 150 112 148 109 143 117 143 125 146 128 153 127
Polygon -955883 false false 170 143 178 145 182 137 182 132 176 128 173 126 168 129 166 126 161 134 161 142 164 145 171 144
Polygon -955883 false false 61 193 53 195 49 187 49 182 55 178 58 176 63 179 65 176 70 184 70 192 67 195 60 194
Polygon -955883 false false 226 250 226 245 224 241 224 248 222 241 223 250 217 244 227 253 221 252 230 253 230 239 228 248 236 243 233 251 238 248 232 253 237 256
Polygon -955883 false false 227 208 227 203 225 199 225 206 223 199 224 208 218 202 228 211 222 210 231 211 231 197 229 206 237 201 234 209 239 206 233 211 238 214
Polygon -955883 false false 215 187 215 182 213 178 213 185 211 178 212 187 206 181 216 190 210 189 219 190 219 176 217 185 225 180 222 188 227 185 221 190 226 193
Polygon -955883 false false 183 245 183 240 181 236 181 243 179 236 180 245 174 239 184 248 178 247 187 248 187 234 185 243 193 238 190 246 195 243 189 248 194 251
Polygon -955883 false false 189 216 189 211 187 207 187 214 185 207 186 216 180 210 190 219 184 218 193 219 193 205 191 214 199 209 196 217 201 214 195 219 200 222
Polygon -955883 false false 192 179 192 174 190 170 190 177 188 170 189 179 183 173 193 182 187 181 196 182 196 168 194 177 202 172 199 180 204 177 198 182 203 185
Polygon -955883 false false 183 155 183 150 181 146 181 153 179 146 180 155 174 149 184 158 178 157 187 158 187 144 185 153 193 148 190 156 195 153 189 158 194 161
Polygon -1184463 true false 188 157 182 154 180 150 183 145 189 145 194 147 194 155 191 159
Polygon -13840069 true false 197 184 191 181 189 177 192 172 198 172 203 174 203 182 200 186
Polygon -13840069 true false 193 219 187 216 185 212 188 207 194 207 199 209 199 217 196 221
Polygon -13840069 true false 188 249 182 246 180 242 183 237 189 237 194 239 194 247 191 251
Polygon -1184463 true false 218 190 212 187 210 183 213 178 219 178 224 180 224 188 221 192
Polygon -13840069 true false 232 213 226 210 224 206 227 201 233 201 238 203 238 211 235 215
Polygon -13840069 true false 230 252 224 249 222 245 225 240 231 240 236 242 236 250 233 254
Polygon -955883 false false 221 189 213 191 209 183 209 178 215 174 218 172 223 175 225 172 230 180 230 188 227 191 220 190
Polygon -955883 false false 188 157 180 159 176 151 176 146 182 142 185 140 190 143 192 140 197 148 197 156 194 159 187 158

pincushion pink
false
8
Polygon -11221820 true true 93 277 88 273 79 271 78 266 78 260 81 254 80 252 76 243 72 237 73 233 75 225 73 219 74 207 79 203 80 195 87 186 90 179 98 174 105 178 117 172 126 167 133 171 142 170 151 164 165 165 177 172 177 181 186 185 202 193 203 202 212 205 220 218 219 227 219 241 221 252 215 265 203 278 196 284 183 284 176 283 167 281 160 284 144 284 135 285 131 279 120 278 110 281 94 280 91 276
Polygon -14835848 true false 195 253 204 252 214 242 215 231 223 222 231 212 232 205 223 209 215 216 207 234 201 241 192 245 190 254 194 260
Polygon -14835848 true false 94 268 85 267 75 257 74 246 66 237 58 227 57 220 66 224 74 231 82 249 88 256 97 260 99 269 95 275
Polygon -14835848 true false 109 233 100 232 90 222 89 211 81 202 73 192 72 185 81 189 89 196 97 214 103 221 112 225 114 234 110 240
Polygon -14835848 true false 161 255 180 247 182 239 188 231 194 217 199 211 186 215 181 225 172 237 166 245 150 248 144 256 157 257
Polygon -14835848 true false 132 280 113 272 111 264 105 256 99 242 94 236 107 240 112 250 121 262 127 270 143 273 149 281 136 282
Polygon -14835848 true false 81 233 76 221 64 211 61 200 60 188 65 190 73 206 80 219 91 230 94 247 86 239
Polygon -14835848 true false 177 222 182 210 194 200 197 189 198 177 193 179 185 195 178 208 167 219 164 236 172 228
Polygon -14835848 true false 148 241 159 230 162 220 165 203 170 194 163 186 159 196 158 207 152 218 145 223 144 234 138 241 144 244
Polygon -14835848 true false 132 254 121 243 118 233 115 216 110 207 117 199 121 209 122 220 128 231 135 236 136 247 142 254 136 257
Polygon -14835848 true false 187 267 200 265 212 261 221 252 230 241 230 251 225 256 218 268 211 268 201 279 189 275 181 274
Polygon -14835848 true false 153 197 157 190 165 180 172 168 174 151 174 134 168 134 169 141 165 155 161 166 155 184 152 188
Polygon -14835848 true false 104 208 100 201 92 191 85 179 83 162 83 145 89 145 88 152 92 166 96 177 102 195 105 199
Polygon -14835848 true false 172 199 177 188 174 182 180 166 184 146 189 150 188 162 184 181
Polygon -14835848 true false 134 215 126 204 121 184 117 170 117 153 123 155 125 174 130 184 137 203 140 220
Polygon -14835848 true false 138 182 133 174 134 164 132 148 131 139 138 147 140 162
Polygon -14835848 true false 108 194 103 170 101 154 103 140 103 125 108 130 110 151 108 173 113 196
Polygon -14835848 true false 142 201 143 183 148 169 146 159 151 137 151 119 157 122 157 135 155 157 153 170 146 185
Polygon -14835848 true false 151 276 161 261 179 257 187 242 188 255 175 266 165 269
Polygon -14835848 true false 195 235 197 224 207 209 202 196 211 188 215 177 220 189 211 200 213 217 205 228
Polygon -2064490 true false 61 197 50 193 51 199 60 200 67 202 74 193 70 191 65 195
Polygon -10899396 true false 77 224 66 220 67 226 76 227 83 229 90 220 86 218 81 222
Polygon -10899396 true false 71 215 60 211 61 217 70 218 77 220 84 211 80 209 75 213
Polygon -10899396 true false 65 205 54 201 55 207 64 208 71 210 78 201 74 199 69 203
Polygon -10899396 true false 93 241 82 237 83 243 92 244 99 246 106 237 102 235 97 239
Polygon -10899396 true false 85 232 74 228 75 234 84 235 91 237 98 228 94 226 89 230
Polygon -2064490 true false 104 247 93 243 94 249 103 250 110 252 117 243 113 241 108 245
Polygon -10899396 true false 125 239 114 235 115 241 124 242 131 244 138 235 134 233 129 237
Polygon -10899396 true false 122 229 111 225 112 231 121 232 128 234 135 225 131 223 126 227
Polygon -2064490 true false 119 219 108 215 109 221 118 222 125 224 132 215 128 213 123 217
Polygon -10899396 true false 114 266 103 262 104 268 113 269 120 271 127 262 123 260 118 264
Polygon -10899396 true false 109 257 98 253 99 259 108 260 115 262 122 253 118 251 113 255
Polygon -2064490 true false 82 198 71 194 72 200 81 201 88 203 95 194 91 192 86 196
Polygon -10899396 true false 89 166 78 162 79 168 88 169 95 171 102 162 98 160 93 164
Polygon -2064490 true false 87 158 76 154 77 160 86 161 93 163 100 154 96 152 91 156
Polygon -10899396 true false 96 223 85 219 86 225 95 226 102 228 109 219 105 217 100 221
Polygon -10899396 true false 91 214 80 210 81 216 90 217 97 219 104 210 100 208 95 212
Polygon -10899396 true false 86 205 75 201 76 207 85 208 92 210 99 201 95 199 90 203
Polygon -10899396 true false 100 200 89 196 90 202 99 203 106 205 113 196 109 194 104 198
Polygon -10899396 true false 94 188 83 184 84 190 93 191 100 193 107 184 103 182 98 186
Polygon -10899396 true false 91 179 80 175 81 181 90 182 97 184 104 175 100 173 95 177
Polygon -2064490 true false 119 165 108 161 109 167 118 168 125 170 132 161 128 159 123 163
Polygon -10899396 true false 127 206 116 202 117 208 126 209 133 211 140 202 136 200 131 204
Polygon -10899396 true false 125 194 114 190 115 196 124 197 131 199 138 190 134 188 129 192
Polygon -10899396 true false 124 185 113 181 114 187 123 188 130 190 137 181 133 179 128 183
Polygon -10899396 true false 121 176 110 172 111 178 120 179 127 181 134 172 130 170 125 174
Polygon -10899396 true false 134 216 123 212 124 218 133 219 140 221 147 212 143 210 138 214
Polygon -2064490 true false 57 232 64 230 70 219 71 227 69 232 54 237 54 231
Polygon -10899396 true false 91 274 98 272 104 261 105 269 103 274 88 279 88 273
Polygon -10899396 true false 82 267 89 265 95 254 96 262 94 267 79 272 79 266
Polygon -10899396 true false 75 260 82 258 88 247 89 255 87 260 72 265 72 259
Polygon -10899396 true false 70 253 77 251 83 240 84 248 82 253 67 258 67 252
Polygon -10899396 true false 66 246 73 244 79 233 80 241 78 246 63 251 63 245
Polygon -10899396 true false 61 239 68 237 74 226 75 234 73 239 58 244 58 238
Polygon -10899396 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -10899396 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -2064490 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -10899396 true false 101 186 100 191 113 199 120 192 119 187 113 194
Polygon -10899396 true false 95 173 94 178 107 186 114 179 113 174 107 181
Polygon -10899396 true false 96 159 95 164 108 172 115 165 114 160 108 167
Polygon -10899396 true false 96 145 95 150 108 158 115 151 114 146 108 153
Polygon -2064490 true false 125 148 124 153 137 161 144 154 143 149 137 156
Polygon -2064490 true false 163 127 164 132 151 140 144 133 145 128 151 135
Polygon -10899396 true false 126 170 125 175 138 183 145 176 144 171 138 178
Polygon -10899396 true false 126 158 125 163 138 171 145 164 144 159 138 166
Polygon -10899396 true false 123 274 112 270 113 276 122 277 129 279 136 270 132 268 127 272
Polygon -10899396 true false 130 281 137 279 143 268 144 276 142 281 127 286 127 280
Polygon -10899396 true false 100 279 107 277 113 266 114 274 112 279 97 284 97 278
Polygon -10899396 true false 168 275 161 273 155 262 154 270 156 275 171 280 171 274
Polygon -10899396 true false 189 279 182 277 176 266 175 274 177 279 192 284 192 278
Polygon -2064490 true false 191 255 184 253 178 242 177 250 179 255 194 260 194 254
Polygon -10899396 true false 182 261 175 259 169 248 168 256 170 261 185 266 185 260
Polygon -10899396 true false 172 268 165 266 159 255 158 263 160 268 175 273 175 267
Polygon -2064490 true false 232 257 225 255 219 244 218 252 220 257 235 262 235 256
Polygon -10899396 true false 224 265 217 263 211 252 210 260 212 265 227 270 227 264
Polygon -10899396 true false 214 274 207 272 201 261 200 269 202 274 217 279 217 273
Polygon -10899396 true false 202 277 195 275 189 264 188 272 190 277 205 282 205 276
Polygon -10899396 true false 152 261 145 259 139 248 138 256 140 261 155 266 155 260
Polygon -10899396 true false 174 252 167 250 161 239 160 247 162 252 177 257 177 251
Polygon -10899396 true false 161 255 154 253 148 242 147 250 149 255 164 260 164 254
Polygon -10899396 true false 209 251 202 249 196 238 195 246 197 251 212 256 212 250
Polygon -10899396 true false 216 244 209 242 203 231 202 239 204 244 219 249 219 243
Polygon -10899396 true false 146 241 157 237 156 243 147 244 140 246 133 237 137 235 142 239
Polygon -2064490 true false 162 201 173 197 172 203 163 204 156 206 149 197 153 195 158 199
Polygon -10899396 true false 156 212 167 208 166 214 157 215 150 217 143 208 147 206 152 210
Polygon -10899396 true false 153 222 164 218 163 224 154 225 147 227 140 218 144 216 149 220
Polygon -10899396 true false 149 233 160 229 159 235 150 236 143 238 136 229 140 227 145 231
Polygon -10899396 true false 176 242 187 238 186 244 177 245 170 247 163 238 167 236 172 240
Polygon -10899396 true false 214 234 225 230 224 236 215 237 208 239 201 230 205 228 210 232
Polygon -2064490 true false 190 222 201 218 200 224 191 225 184 227 177 218 181 216 186 220
Polygon -10899396 true false 183 232 194 228 193 234 184 235 177 237 170 228 174 226 179 230
Polygon -10899396 true false 208 198 219 194 218 200 209 201 202 203 195 194 199 192 204 196
Polygon -10899396 true false 207 208 218 204 217 210 208 211 201 213 194 204 198 202 203 206
Polygon -10899396 true false 204 219 215 215 214 221 205 222 198 224 191 215 195 213 200 217
Polygon -2064490 true false 221 195 214 193 208 182 207 190 209 195 224 200 224 194
Polygon -2064490 true false 234 217 227 215 221 204 220 212 222 217 237 222 237 216
Polygon -10899396 true false 228 224 221 222 215 211 214 219 216 224 231 229 231 223
Polygon -10899396 true false 167 225 178 221 177 227 168 228 161 230 154 221 158 219 163 223
Polygon -2064490 true false 195 187 206 183 205 189 196 190 189 192 182 183 186 181 191 185
Polygon -10899396 true false 191 196 202 192 201 198 192 199 185 201 178 192 182 190 187 194
Polygon -10899396 true false 185 206 196 202 195 208 186 209 179 211 172 202 176 200 181 204
Polygon -10899396 true false 175 215 186 211 185 217 176 218 169 220 162 211 166 209 171 213
Polygon -10899396 true false 156 173 157 178 144 186 137 179 138 174 144 181
Polygon -10899396 true false 158 161 159 166 146 174 139 167 140 162 146 169
Polygon -10899396 true false 161 148 162 153 149 161 142 154 143 149 149 156
Polygon -10899396 true false 162 137 163 142 150 150 143 143 144 138 150 145
Polygon -10899396 true false 152 195 153 200 140 208 133 201 134 196 140 203
Polygon -10899396 true false 154 185 155 190 142 198 135 191 136 186 142 193
Polygon -2064490 true false 180 142 181 147 168 155 161 148 162 143 168 150
Polygon -2064490 true false 195 158 196 163 183 171 176 164 177 159 183 166
Polygon -10899396 true false 179 152 180 157 167 165 160 158 161 153 167 160
Polygon -10899396 true false 182 174 193 170 192 176 183 177 176 179 169 170 173 168 178 172
Polygon -10899396 true false 163 180 174 176 173 182 164 183 157 185 150 176 154 174 159 178
Polygon -10899396 true false 178 187 189 183 188 189 179 190 172 192 165 183 169 181 174 185
Polygon -10899396 true false 164 169 175 165 174 171 165 172 158 174 151 165 155 163 160 167
Polygon -2674135 false false 106 131 106 126 108 122 109 127 110 122 109 131 115 125 105 134 111 133 102 134 102 120 104 129 96 124 99 132 94 129 100 134 95 137
Polygon -2674135 false false 116 209 116 204 118 200 119 205 120 200 119 209 125 203 115 212 121 211 112 212 112 198 114 207 106 202 109 210 104 207 110 212 105 215
Polygon -2674135 false false 86 151 86 146 88 142 89 147 90 142 89 151 95 145 85 154 91 153 82 154 82 140 84 149 76 144 79 152 74 149 80 154 75 157
Polygon -2674135 false false 103 238 103 233 105 229 106 234 107 229 106 238 112 232 102 241 108 240 99 241 99 227 101 236 93 231 96 239 91 236 97 241 92 244
Polygon -2674135 false false 79 189 79 184 81 180 82 185 83 180 82 189 88 183 78 192 84 191 75 192 75 178 77 187 69 182 72 190 67 187 73 192 68 195
Polygon -2674135 false false 63 189 63 184 65 180 66 185 67 180 66 189 72 183 62 192 68 191 59 192 59 178 61 187 53 182 56 190 51 187 57 192 52 195
Polygon -2674135 false false 58 222 58 217 60 213 61 218 62 213 61 222 67 216 57 225 63 224 54 225 54 211 56 220 48 215 51 223 46 220 52 225 47 228
Polygon -2674135 false false 131 257 131 252 133 248 134 253 135 248 134 257 140 251 130 260 136 259 127 260 127 246 129 255 121 250 124 258 119 255 125 260 120 263
Polygon -2674135 false false 121 155 121 150 123 146 124 151 125 146 124 155 130 149 120 158 126 157 117 158 117 144 119 153 111 148 114 156 109 153 115 158 110 161
Polygon -2674135 false false 137 186 137 181 139 177 140 182 141 177 140 186 146 180 136 189 142 188 133 189 133 175 135 184 127 179 130 187 125 184 131 189 126 192
Polygon -7500403 true false 102 243 96 240 94 236 97 231 103 231 108 233 108 241 105 245
Polygon -7500403 true false 130 261 124 258 122 254 125 249 131 249 136 251 136 259 133 263
Polygon -7500403 true false 57 228 51 225 49 221 52 216 58 216 63 218 63 226 60 230
Polygon -1 true false 62 193 56 190 54 186 57 181 63 181 68 183 68 191 65 195
Polygon -7500403 true false 79 193 73 190 71 186 74 181 80 181 85 183 85 191 82 195
Polygon -1 true false 85 154 79 151 77 147 80 142 86 142 91 144 91 152 88 156
Polygon -7500403 true false 116 212 110 209 108 205 111 200 117 200 122 202 122 210 119 214
Polygon -1 true false 105 135 99 132 97 128 100 123 106 123 111 125 111 133 108 137
Polygon -7500403 true false 120 160 114 157 112 153 115 148 121 148 126 150 126 158 123 162
Polygon -7500403 true false 136 190 130 187 128 183 131 178 137 178 142 180 142 188 139 192
Polygon -2064490 false false 86 153 78 155 74 147 74 142 80 138 83 136 88 139 90 136 95 144 95 152 92 155 85 154
Polygon -2064490 false false 106 133 98 135 94 127 94 122 100 118 103 116 108 119 110 116 115 124 115 132 112 135 105 134
Polygon -2674135 false false 168 140 168 135 166 131 166 138 164 131 165 140 159 134 169 143 163 142 172 143 172 129 170 138 178 133 175 141 180 138 174 143 179 146
Polygon -2674135 false false 141 217 141 212 139 208 139 215 137 208 138 217 132 211 142 220 136 219 145 220 145 206 143 215 151 210 148 218 153 215 147 220 152 223
Polygon -2674135 false false 161 193 161 188 159 184 159 191 157 184 158 193 152 187 162 196 156 195 165 196 165 182 163 191 171 186 168 194 173 191 167 196 172 199
Polygon -2674135 false false 132 145 132 140 130 136 130 143 128 136 129 145 123 139 133 148 127 147 136 148 136 134 134 143 142 138 139 146 144 143 138 148 143 151
Polygon -2674135 false false 150 123 150 118 148 114 148 121 146 114 147 123 141 117 151 126 145 125 154 126 154 112 152 121 160 116 157 124 162 121 156 126 161 129
Polygon -1 true false 154 127 148 124 146 120 149 115 155 115 160 117 160 125 157 129
Polygon -7500403 true false 136 148 130 145 128 141 131 136 137 136 142 138 142 146 139 150
Polygon -7500403 true false 165 196 159 193 157 189 160 184 166 184 171 186 171 194 168 198
Polygon -7500403 true false 146 220 140 217 138 213 141 208 147 208 152 210 152 218 149 222
Polygon -1 true false 172 143 166 140 164 136 167 131 173 131 178 133 178 141 175 145
Polygon -2064490 false false 152 126 160 128 164 120 164 115 158 111 155 109 150 112 148 109 143 117 143 125 146 128 153 127
Polygon -2064490 false false 170 143 178 145 182 137 182 132 176 128 173 126 168 129 166 126 161 134 161 142 164 145 171 144
Polygon -2064490 false false 61 193 53 195 49 187 49 182 55 178 58 176 63 179 65 176 70 184 70 192 67 195 60 194
Polygon -2674135 false false 226 250 226 245 224 241 224 248 222 241 223 250 217 244 227 253 221 252 230 253 230 239 228 248 236 243 233 251 238 248 232 253 237 256
Polygon -2674135 false false 227 208 227 203 225 199 225 206 223 199 224 208 218 202 228 211 222 210 231 211 231 197 229 206 237 201 234 209 239 206 233 211 238 214
Polygon -2674135 false false 215 187 215 182 213 178 213 185 211 178 212 187 206 181 216 190 210 189 219 190 219 176 217 185 225 180 222 188 227 185 221 190 226 193
Polygon -2674135 false false 183 245 183 240 181 236 181 243 179 236 180 245 174 239 184 248 178 247 187 248 187 234 185 243 193 238 190 246 195 243 189 248 194 251
Polygon -2674135 false false 189 216 189 211 187 207 187 214 185 207 186 216 180 210 190 219 184 218 193 219 193 205 191 214 199 209 196 217 201 214 195 219 200 222
Polygon -2674135 false false 192 179 192 174 190 170 190 177 188 170 189 179 183 173 193 182 187 181 196 182 196 168 194 177 202 172 199 180 204 177 198 182 203 185
Polygon -2674135 false false 183 155 183 150 181 146 181 153 179 146 180 155 174 149 184 158 178 157 187 158 187 144 185 153 193 148 190 156 195 153 189 158 194 161
Polygon -1 true false 188 157 182 154 180 150 183 145 189 145 194 147 194 155 191 159
Polygon -7500403 true false 197 184 191 181 189 177 192 172 198 172 203 174 203 182 200 186
Polygon -7500403 true false 193 219 187 216 185 212 188 207 194 207 199 209 199 217 196 221
Polygon -7500403 true false 188 249 182 246 180 242 183 237 189 237 194 239 194 247 191 251
Polygon -1 true false 218 190 212 187 210 183 213 178 219 178 224 180 224 188 221 192
Polygon -7500403 true false 232 213 226 210 224 206 227 201 233 201 238 203 238 211 235 215
Polygon -7500403 true false 230 252 224 249 222 245 225 240 231 240 236 242 236 250 233 254
Polygon -2064490 false false 221 189 213 191 209 183 209 178 215 174 218 172 223 175 225 172 230 180 230 188 227 191 220 190
Polygon -2064490 false false 188 157 180 159 176 151 176 146 182 142 185 140 190 143 192 140 197 148 197 156 194 159 187 158

pincushion red
false
8
Polygon -11221820 true true 93 277 88 273 79 271 78 266 78 260 81 254 80 252 76 243 72 237 73 233 75 225 73 219 74 207 79 203 80 195 87 186 90 179 98 174 105 178 117 172 126 167 133 171 142 170 151 164 165 165 177 172 177 181 186 185 202 193 203 202 212 205 220 218 219 227 219 241 221 252 215 265 203 278 196 284 183 284 176 283 167 281 160 284 144 284 135 285 131 279 120 278 110 281 94 280 91 276
Polygon -14835848 true false 195 253 204 252 214 242 215 231 223 222 231 212 232 205 223 209 215 216 207 234 201 241 192 245 190 254 194 260
Polygon -14835848 true false 94 268 85 267 75 257 74 246 66 237 58 227 57 220 66 224 74 231 82 249 88 256 97 260 99 269 95 275
Polygon -14835848 true false 109 233 100 232 90 222 89 211 81 202 73 192 72 185 81 189 89 196 97 214 103 221 112 225 114 234 110 240
Polygon -14835848 true false 161 255 180 247 182 239 188 231 194 217 199 211 186 215 181 225 172 237 166 245 150 248 144 256 157 257
Polygon -14835848 true false 132 280 113 272 111 264 105 256 99 242 94 236 107 240 112 250 121 262 127 270 143 273 149 281 136 282
Polygon -14835848 true false 81 233 76 221 64 211 61 200 60 188 65 190 73 206 80 219 91 230 94 247 86 239
Polygon -14835848 true false 177 222 182 210 194 200 197 189 198 177 193 179 185 195 178 208 167 219 164 236 172 228
Polygon -14835848 true false 148 241 159 230 162 220 165 203 170 194 163 186 159 196 158 207 152 218 145 223 144 234 138 241 144 244
Polygon -14835848 true false 132 254 121 243 118 233 115 216 110 207 117 199 121 209 122 220 128 231 135 236 136 247 142 254 136 257
Polygon -14835848 true false 187 267 200 265 212 261 221 252 230 241 230 251 225 256 218 268 211 268 201 279 189 275 181 274
Polygon -14835848 true false 153 197 157 190 165 180 172 168 174 151 174 134 168 134 169 141 165 155 161 166 155 184 152 188
Polygon -14835848 true false 104 208 100 201 92 191 85 179 83 162 83 145 89 145 88 152 92 166 96 177 102 195 105 199
Polygon -14835848 true false 172 199 177 188 174 182 180 166 184 146 189 150 188 162 184 181
Polygon -14835848 true false 134 215 126 204 121 184 117 170 117 153 123 155 125 174 130 184 137 203 140 220
Polygon -14835848 true false 138 182 133 174 134 164 132 148 131 139 138 147 140 162
Polygon -14835848 true false 108 194 103 170 101 154 103 140 103 125 108 130 110 151 108 173 113 196
Polygon -14835848 true false 142 201 143 183 148 169 146 159 151 137 151 119 157 122 157 135 155 157 153 170 146 185
Polygon -14835848 true false 151 276 161 261 179 257 187 242 188 255 175 266 165 269
Polygon -14835848 true false 195 235 197 224 207 209 202 196 211 188 215 177 220 189 211 200 213 217 205 228
Polygon -10899396 true false 61 197 50 193 51 199 60 200 67 202 74 193 70 191 65 195
Polygon -10899396 true false 77 224 66 220 67 226 76 227 83 229 90 220 86 218 81 222
Polygon -10899396 true false 71 215 60 211 61 217 70 218 77 220 84 211 80 209 75 213
Polygon -10899396 true false 65 205 54 201 55 207 64 208 71 210 78 201 74 199 69 203
Polygon -10899396 true false 93 241 82 237 83 243 92 244 99 246 106 237 102 235 97 239
Polygon -10899396 true false 85 232 74 228 75 234 84 235 91 237 98 228 94 226 89 230
Polygon -10899396 true false 104 247 93 243 94 249 103 250 110 252 117 243 113 241 108 245
Polygon -10899396 true false 125 239 114 235 115 241 124 242 131 244 138 235 134 233 129 237
Polygon -10899396 true false 122 229 111 225 112 231 121 232 128 234 135 225 131 223 126 227
Polygon -10899396 true false 119 219 108 215 109 221 118 222 125 224 132 215 128 213 123 217
Polygon -10899396 true false 114 266 103 262 104 268 113 269 120 271 127 262 123 260 118 264
Polygon -10899396 true false 109 257 98 253 99 259 108 260 115 262 122 253 118 251 113 255
Polygon -10899396 true false 82 198 71 194 72 200 81 201 88 203 95 194 91 192 86 196
Polygon -10899396 true false 89 166 78 162 79 168 88 169 95 171 102 162 98 160 93 164
Polygon -10899396 true false 87 158 76 154 77 160 86 161 93 163 100 154 96 152 91 156
Polygon -10899396 true false 96 223 85 219 86 225 95 226 102 228 109 219 105 217 100 221
Polygon -10899396 true false 91 214 80 210 81 216 90 217 97 219 104 210 100 208 95 212
Polygon -10899396 true false 86 205 75 201 76 207 85 208 92 210 99 201 95 199 90 203
Polygon -10899396 true false 100 200 89 196 90 202 99 203 106 205 113 196 109 194 104 198
Polygon -10899396 true false 94 188 83 184 84 190 93 191 100 193 107 184 103 182 98 186
Polygon -10899396 true false 91 179 80 175 81 181 90 182 97 184 104 175 100 173 95 177
Polygon -10899396 true false 119 165 108 161 109 167 118 168 125 170 132 161 128 159 123 163
Polygon -10899396 true false 127 206 116 202 117 208 126 209 133 211 140 202 136 200 131 204
Polygon -10899396 true false 125 194 114 190 115 196 124 197 131 199 138 190 134 188 129 192
Polygon -10899396 true false 124 185 113 181 114 187 123 188 130 190 137 181 133 179 128 183
Polygon -10899396 true false 121 176 110 172 111 178 120 179 127 181 134 172 130 170 125 174
Polygon -10899396 true false 134 216 123 212 124 218 133 219 140 221 147 212 143 210 138 214
Polygon -10899396 true false 57 232 64 230 70 219 71 227 69 232 54 237 54 231
Polygon -10899396 true false 91 274 98 272 104 261 105 269 103 274 88 279 88 273
Polygon -10899396 true false 82 267 89 265 95 254 96 262 94 267 79 272 79 266
Polygon -10899396 true false 75 260 82 258 88 247 89 255 87 260 72 265 72 259
Polygon -10899396 true false 70 253 77 251 83 240 84 248 82 253 67 258 67 252
Polygon -10899396 true false 66 246 73 244 79 233 80 241 78 246 63 251 63 245
Polygon -10899396 true false 61 239 68 237 74 226 75 234 73 239 58 244 58 238
Polygon -10899396 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -10899396 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -10899396 true false 96 134 95 139 108 147 115 140 114 135 108 142
Polygon -10899396 true false 101 186 100 191 113 199 120 192 119 187 113 194
Polygon -10899396 true false 95 173 94 178 107 186 114 179 113 174 107 181
Polygon -10899396 true false 96 159 95 164 108 172 115 165 114 160 108 167
Polygon -10899396 true false 96 145 95 150 108 158 115 151 114 146 108 153
Polygon -10899396 true false 125 148 124 153 137 161 144 154 143 149 137 156
Polygon -10899396 true false 163 127 164 132 151 140 144 133 145 128 151 135
Polygon -10899396 true false 126 170 125 175 138 183 145 176 144 171 138 178
Polygon -10899396 true false 126 158 125 163 138 171 145 164 144 159 138 166
Polygon -10899396 true false 123 274 112 270 113 276 122 277 129 279 136 270 132 268 127 272
Polygon -10899396 true false 130 281 137 279 143 268 144 276 142 281 127 286 127 280
Polygon -10899396 true false 100 279 107 277 113 266 114 274 112 279 97 284 97 278
Polygon -10899396 true false 168 275 161 273 155 262 154 270 156 275 171 280 171 274
Polygon -10899396 true false 189 279 182 277 176 266 175 274 177 279 192 284 192 278
Polygon -10899396 true false 191 255 184 253 178 242 177 250 179 255 194 260 194 254
Polygon -10899396 true false 182 261 175 259 169 248 168 256 170 261 185 266 185 260
Polygon -10899396 true false 172 268 165 266 159 255 158 263 160 268 175 273 175 267
Polygon -10899396 true false 232 257 225 255 219 244 218 252 220 257 235 262 235 256
Polygon -10899396 true false 224 265 217 263 211 252 210 260 212 265 227 270 227 264
Polygon -10899396 true false 214 274 207 272 201 261 200 269 202 274 217 279 217 273
Polygon -10899396 true false 202 277 195 275 189 264 188 272 190 277 205 282 205 276
Polygon -10899396 true false 152 261 145 259 139 248 138 256 140 261 155 266 155 260
Polygon -10899396 true false 174 252 167 250 161 239 160 247 162 252 177 257 177 251
Polygon -10899396 true false 161 255 154 253 148 242 147 250 149 255 164 260 164 254
Polygon -10899396 true false 209 251 202 249 196 238 195 246 197 251 212 256 212 250
Polygon -10899396 true false 216 244 209 242 203 231 202 239 204 244 219 249 219 243
Polygon -10899396 true false 146 241 157 237 156 243 147 244 140 246 133 237 137 235 142 239
Polygon -10899396 true false 162 201 173 197 172 203 163 204 156 206 149 197 153 195 158 199
Polygon -10899396 true false 156 212 167 208 166 214 157 215 150 217 143 208 147 206 152 210
Polygon -10899396 true false 153 222 164 218 163 224 154 225 147 227 140 218 144 216 149 220
Polygon -10899396 true false 149 233 160 229 159 235 150 236 143 238 136 229 140 227 145 231
Polygon -10899396 true false 176 242 187 238 186 244 177 245 170 247 163 238 167 236 172 240
Polygon -10899396 true false 214 234 225 230 224 236 215 237 208 239 201 230 205 228 210 232
Polygon -10899396 true false 190 222 201 218 200 224 191 225 184 227 177 218 181 216 186 220
Polygon -10899396 true false 183 232 194 228 193 234 184 235 177 237 170 228 174 226 179 230
Polygon -10899396 true false 208 198 219 194 218 200 209 201 202 203 195 194 199 192 204 196
Polygon -10899396 true false 207 208 218 204 217 210 208 211 201 213 194 204 198 202 203 206
Polygon -10899396 true false 204 219 215 215 214 221 205 222 198 224 191 215 195 213 200 217
Polygon -10899396 true false 221 195 214 193 208 182 207 190 209 195 224 200 224 194
Polygon -10899396 true false 234 217 227 215 221 204 220 212 222 217 237 222 237 216
Polygon -10899396 true false 228 224 221 222 215 211 214 219 216 224 231 229 231 223
Polygon -10899396 true false 167 225 178 221 177 227 168 228 161 230 154 221 158 219 163 223
Polygon -10899396 true false 195 187 206 183 205 189 196 190 189 192 182 183 186 181 191 185
Polygon -10899396 true false 191 196 202 192 201 198 192 199 185 201 178 192 182 190 187 194
Polygon -10899396 true false 185 206 196 202 195 208 186 209 179 211 172 202 176 200 181 204
Polygon -10899396 true false 175 215 186 211 185 217 176 218 169 220 162 211 166 209 171 213
Polygon -10899396 true false 156 173 157 178 144 186 137 179 138 174 144 181
Polygon -10899396 true false 158 161 159 166 146 174 139 167 140 162 146 169
Polygon -10899396 true false 161 148 162 153 149 161 142 154 143 149 149 156
Polygon -10899396 true false 162 137 163 142 150 150 143 143 144 138 150 145
Polygon -10899396 true false 152 195 153 200 140 208 133 201 134 196 140 203
Polygon -10899396 true false 154 185 155 190 142 198 135 191 136 186 142 193
Polygon -10899396 true false 180 142 181 147 168 155 161 148 162 143 168 150
Polygon -10899396 true false 195 158 196 163 183 171 176 164 177 159 183 166
Polygon -10899396 true false 179 152 180 157 167 165 160 158 161 153 167 160
Polygon -10899396 true false 182 174 193 170 192 176 183 177 176 179 169 170 173 168 178 172
Polygon -10899396 true false 163 180 174 176 173 182 164 183 157 185 150 176 154 174 159 178
Polygon -10899396 true false 178 187 189 183 188 189 179 190 172 192 165 183 169 181 174 185
Polygon -10899396 true false 164 169 175 165 174 171 165 172 158 174 151 165 155 163 160 167
Polygon -2674135 false false 106 131 106 126 108 122 109 127 110 122 109 131 115 125 105 134 111 133 102 134 102 120 104 129 96 124 99 132 94 129 100 134 95 137
Polygon -2674135 false false 116 209 116 204 118 200 119 205 120 200 119 209 125 203 115 212 121 211 112 212 112 198 114 207 106 202 109 210 104 207 110 212 105 215
Polygon -2674135 false false 86 151 86 146 88 142 89 147 90 142 89 151 95 145 85 154 91 153 82 154 82 140 84 149 76 144 79 152 74 149 80 154 75 157
Polygon -2674135 false false 103 238 103 233 105 229 106 234 107 229 106 238 112 232 102 241 108 240 99 241 99 227 101 236 93 231 96 239 91 236 97 241 92 244
Polygon -2674135 false false 79 189 79 184 81 180 82 185 83 180 82 189 88 183 78 192 84 191 75 192 75 178 77 187 69 182 72 190 67 187 73 192 68 195
Polygon -2674135 false false 63 189 63 184 65 180 66 185 67 180 66 189 72 183 62 192 68 191 59 192 59 178 61 187 53 182 56 190 51 187 57 192 52 195
Polygon -2674135 false false 58 222 58 217 60 213 61 218 62 213 61 222 67 216 57 225 63 224 54 225 54 211 56 220 48 215 51 223 46 220 52 225 47 228
Polygon -2674135 false false 131 257 131 252 133 248 134 253 135 248 134 257 140 251 130 260 136 259 127 260 127 246 129 255 121 250 124 258 119 255 125 260 120 263
Polygon -2674135 false false 121 155 121 150 123 146 124 151 125 146 124 155 130 149 120 158 126 157 117 158 117 144 119 153 111 148 114 156 109 153 115 158 110 161
Polygon -2674135 false false 137 186 137 181 139 177 140 182 141 177 140 186 146 180 136 189 142 188 133 189 133 175 135 184 127 179 130 187 125 184 131 189 126 192
Polygon -2064490 true false 102 243 96 240 94 236 97 231 103 231 108 233 108 241 105 245
Polygon -2064490 true false 130 261 124 258 122 254 125 249 131 249 136 251 136 259 133 263
Polygon -2064490 true false 57 228 51 225 49 221 52 216 58 216 63 218 63 226 60 230
Polygon -1184463 true false 62 193 56 190 54 186 57 181 63 181 68 183 68 191 65 195
Polygon -2064490 true false 79 193 73 190 71 186 74 181 80 181 85 183 85 191 82 195
Polygon -1184463 true false 85 154 79 151 77 147 80 142 86 142 91 144 91 152 88 156
Polygon -2064490 true false 116 212 110 209 108 205 111 200 117 200 122 202 122 210 119 214
Polygon -1184463 true false 105 135 99 132 97 128 100 123 106 123 111 125 111 133 108 137
Polygon -2064490 true false 120 160 114 157 112 153 115 148 121 148 126 150 126 158 123 162
Polygon -2064490 true false 136 190 130 187 128 183 131 178 137 178 142 180 142 188 139 192
Polygon -2674135 false false 86 153 78 155 74 147 74 142 80 138 83 136 88 139 90 136 95 144 95 152 92 155 85 154
Polygon -2674135 false false 106 133 98 135 94 127 94 122 100 118 103 116 108 119 110 116 115 124 115 132 112 135 105 134
Polygon -2674135 false false 168 140 168 135 166 131 166 138 164 131 165 140 159 134 169 143 163 142 172 143 172 129 170 138 178 133 175 141 180 138 174 143 179 146
Polygon -2674135 false false 141 217 141 212 139 208 139 215 137 208 138 217 132 211 142 220 136 219 145 220 145 206 143 215 151 210 148 218 153 215 147 220 152 223
Polygon -2674135 false false 161 193 161 188 159 184 159 191 157 184 158 193 152 187 162 196 156 195 165 196 165 182 163 191 171 186 168 194 173 191 167 196 172 199
Polygon -2674135 false false 132 145 132 140 130 136 130 143 128 136 129 145 123 139 133 148 127 147 136 148 136 134 134 143 142 138 139 146 144 143 138 148 143 151
Polygon -2674135 false false 150 123 150 118 148 114 148 121 146 114 147 123 141 117 151 126 145 125 154 126 154 112 152 121 160 116 157 124 162 121 156 126 161 129
Polygon -1184463 true false 154 127 148 124 146 120 149 115 155 115 160 117 160 125 157 129
Polygon -2064490 true false 136 148 130 145 128 141 131 136 137 136 142 138 142 146 139 150
Polygon -2064490 true false 165 196 159 193 157 189 160 184 166 184 171 186 171 194 168 198
Polygon -2064490 true false 146 220 140 217 138 213 141 208 147 208 152 210 152 218 149 222
Polygon -1184463 true false 172 143 166 140 164 136 167 131 173 131 178 133 178 141 175 145
Polygon -2674135 false false 152 126 160 128 164 120 164 115 158 111 155 109 150 112 148 109 143 117 143 125 146 128 153 127
Polygon -2674135 false false 170 143 178 145 182 137 182 132 176 128 173 126 168 129 166 126 161 134 161 142 164 145 171 144
Polygon -2674135 false false 61 193 53 195 49 187 49 182 55 178 58 176 63 179 65 176 70 184 70 192 67 195 60 194
Polygon -2674135 false false 226 250 226 245 224 241 224 248 222 241 223 250 217 244 227 253 221 252 230 253 230 239 228 248 236 243 233 251 238 248 232 253 237 256
Polygon -2674135 false false 227 208 227 203 225 199 225 206 223 199 224 208 218 202 228 211 222 210 231 211 231 197 229 206 237 201 234 209 239 206 233 211 238 214
Polygon -2674135 false false 215 187 215 182 213 178 213 185 211 178 212 187 206 181 216 190 210 189 219 190 219 176 217 185 225 180 222 188 227 185 221 190 226 193
Polygon -2674135 false false 183 245 183 240 181 236 181 243 179 236 180 245 174 239 184 248 178 247 187 248 187 234 185 243 193 238 190 246 195 243 189 248 194 251
Polygon -2674135 false false 189 216 189 211 187 207 187 214 185 207 186 216 180 210 190 219 184 218 193 219 193 205 191 214 199 209 196 217 201 214 195 219 200 222
Polygon -2674135 false false 192 179 192 174 190 170 190 177 188 170 189 179 183 173 193 182 187 181 196 182 196 168 194 177 202 172 199 180 204 177 198 182 203 185
Polygon -2674135 false false 183 155 183 150 181 146 181 153 179 146 180 155 174 149 184 158 178 157 187 158 187 144 185 153 193 148 190 156 195 153 189 158 194 161
Polygon -1184463 true false 188 157 182 154 180 150 183 145 189 145 194 147 194 155 191 159
Polygon -2064490 true false 197 184 191 181 189 177 192 172 198 172 203 174 203 182 200 186
Polygon -2064490 true false 193 219 187 216 185 212 188 207 194 207 199 209 199 217 196 221
Polygon -2064490 true false 188 249 182 246 180 242 183 237 189 237 194 239 194 247 191 251
Polygon -1184463 true false 218 190 212 187 210 183 213 178 219 178 224 180 224 188 221 192
Polygon -2064490 true false 232 213 226 210 224 206 227 201 233 201 238 203 238 211 235 215
Polygon -2064490 true false 230 252 224 249 222 245 225 240 231 240 236 242 236 250 233 254
Polygon -2674135 false false 221 189 213 191 209 183 209 178 215 174 218 172 223 175 225 172 230 180 230 188 227 191 220 190
Polygon -2674135 false false 188 157 180 159 176 151 176 146 182 142 185 140 190 143 192 140 197 148 197 156 194 159 187 158

plain shop island
false
0
Polygon -6459832 true false -1 301 -1 256 59 181 239 181 299 256 299 301
Line -16777216 false 0 255 300 255
Line -16777216 false 60 180 0 255
Line -16777216 false 0 255 0 300
Line -16777216 false 0 300 300 300
Line -16777216 false 300 300 300 255
Line -16777216 false 300 255 240 180
Line -16777216 false 240 150 240 150
Line -16777216 false 60 180 240 180
Polygon -6459832 true false 60 240 60 195 75 165 225 165 240 195 240 240
Line -16777216 false 60 195 75 165
Polygon -7500403 true true 240 195 300 255 240 225
Polygon -7500403 true true 239 179 225 165 232 181
Polygon -7500403 true true 60 195 0 255 60 225
Polygon -7500403 true true 61 179 75 165 68 181
Rectangle -16777216 false false 60 194 241 225
Line -16777216 false 225 165 240 195
Rectangle -6459832 true false 105 105 195 105
Rectangle -6459832 true false 105 150 195 180
Rectangle -16777216 false false 105 150 195 180
Polygon -6459832 true false 105 150 120 135 180 135 195 150
Polygon -16777216 false false 120 135 105 150 195 150 180 135
Polygon -7500403 true true 112 194 90 255 111 226
Polygon -7500403 true true 182 194 207 255 182 225
Rectangle -1 true false 6 261 30 273
Rectangle -1 true false 97 261 121 273
Rectangle -1 true false 214 261 238 273
Rectangle -1 true false 64 198 80 206
Rectangle -1 true false 118 198 134 206
Rectangle -1 true false 191 198 207 206
Rectangle -1 true false 113 154 129 162
Rectangle -1 true false 105 90 195 120
Rectangle -16777216 false false 105 90 195 120
Rectangle -16777216 true false 144 120 158 144
Circle -16777216 true false 8 263 8
Circle -16777216 true false 98 262 8
Circle -16777216 true false 217 262 8
Circle -16777216 true false 192 198 6
Circle -16777216 true false 118 199 6
Circle -16777216 true false 66 199 6
Circle -16777216 true false 115 155 6
Rectangle -16777216 true false 0 285 300 300

plain top shelf 4
false
11
Rectangle -8630108 true true 45 180 255 300
Rectangle -16777216 true false 0 285 300 300
Rectangle -16777216 true false 45 181 54 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 0 195 45 180 255 180 300 195
Rectangle -16777216 true false 0 195 300 200
Rectangle -1 true false 36 195 54 200
Rectangle -1 true false 93 195 111 200
Rectangle -1 true false 177 195 195 200
Polygon -6459832 true false 0 225 45 210 255 210 300 225
Polygon -6459832 true false 0 285 45 270 255 270 300 285
Rectangle -16777216 true false 0 285 300 290
Rectangle -16777216 true false 0 225 300 230
Rectangle -1 true false 36 225 54 230
Rectangle -1 true false 85 224 103 229
Rectangle -1 true false 244 225 262 230
Rectangle -1 true false 36 285 54 290
Rectangle -1 true false 178 286 196 291
Rectangle -1 true false 268 285 286 290
Rectangle -16777216 true false 0 196 9 300
Rectangle -1 true false 222 195 240 200
Rectangle -1 true false 215 225 233 230
Rectangle -1 true false 219 287 237 292
Polygon -6459832 true false 0 255 45 240 255 240 300 255
Rectangle -16777216 true false 0 255 300 260
Rectangle -1 true false 36 255 54 260
Rectangle -1 true false 76 254 94 259
Rectangle -1 true false 217 255 235 260
Rectangle -1 true false 268 254 286 259
Polygon -13345367 true false 268 201 232 201 245 224 279 224
Polygon -1 true false 41 202 77 202 64 225 30 225
Polygon -955883 true false 275 259 239 259 252 282 286 282
Polygon -1184463 true false 280 230 244 230 257 253 291 253
Polygon -11221820 true false 31 262 67 262 54 285 20 285
Polygon -1 true false 32 231 68 231 55 254 21 254
Polygon -2674135 true false 85 201 121 201 108 224 74 224
Polygon -14835848 true false 79 230 115 230 102 253 68 253
Polygon -11221820 true false 74 261 110 261 97 284 63 284
Polygon -1 true false 236 260 200 260 213 283 247 283
Polygon -1184463 true false 233 231 197 231 210 254 244 254
Polygon -13345367 true false 229 202 193 202 206 225 240 225
Polygon -13840069 true false 188 202 162 203 165 225 196 226
Polygon -1 true false 194 260 168 261 171 283 202 284
Polygon -13840069 true false 187 230 161 231 164 253 195 254
Polygon -2674135 true false 125 201 151 202 148 224 117 225
Polygon -2064490 true false 121 229 147 230 144 252 113 253
Polygon -2064490 true false 118 261 144 262 141 284 110 285
Rectangle -16777216 true false 291 196 300 300
Rectangle -16777216 true false 150 196 159 300
Polygon -7500403 true false 42 182 37 187 42 188 40 191 101 191 98 189 102 186 98 183
Polygon -2674135 true false 45 181 42 187 59 186 56 182
Polygon -7500403 true false 44 173 39 178 44 179 42 182 103 182 100 180 104 177 100 174
Polygon -2674135 true false 46 173 43 179 60 178 57 174
Polygon -7500403 true false 113 183 108 188 113 189 111 192 172 192 169 190 173 187 169 184
Polygon -13345367 true false 115 184 112 190 129 189 126 185
Polygon -7500403 true false 114 177 109 182 114 183 112 186 173 186 170 184 174 181 170 178
Polygon -13345367 true false 116 176 113 182 130 181 127 177
Polygon -7500403 true false 195 183 190 188 195 189 193 192 254 192 251 190 255 187 251 184
Polygon -13345367 true false 199 182 196 188 213 187 210 183
Polygon -16777216 false false 45 203 37 223 62 222 70 204
Polygon -16777216 false false 33 263 25 283 50 282 58 264
Polygon -16777216 false false 278 232 286 252 261 251 253 233
Polygon -16777216 false false 35 232 27 252 52 251 60 233
Polygon -16777216 false false 225 203 233 223 208 222 200 204
Polygon -16777216 false false 229 232 237 252 212 251 204 233
Polygon -13791810 true false 210 242 234 242 234 249 216 249
Polygon -13791810 true false 258 242 282 242 282 249 264 249
Circle -16777216 true false 87 203 12
Polygon -1184463 true false 95 216 89 218 104 220 110 208 100 208
Polygon -2674135 true false 37 234 34 242 56 241 59 234
Polygon -2674135 true false 44 206 41 214 63 213 66 206
Polygon -13840069 true false 84 234 81 246 98 248 105 238
Polygon -1 true false 76 248 76 240 91 244 89 250
Polygon -5825686 false false 167 235 167 239 184 238 183 230 168 235
Circle -5825686 true false 174 245 7
Circle -5825686 true false 165 238 8
Polygon -14835848 true false 181 243 187 248 187 245
Polygon -5825686 false false 167 208 167 212 184 211 183 203 168 208
Circle -5825686 true false 166 212 8
Circle -5825686 true false 175 216 7
Polygon -14835848 true false 182 216 188 221 188 218
Circle -16777216 true false 125 203 12
Polygon -1184463 true false 132 220 126 222 141 224 147 212 137 212
Polygon -1184463 false false 271 260 279 280 254 279 246 261
Polygon -16777216 false false 78 261 70 281 95 280 103 262
Circle -16777216 false false 172 260 24
Circle -16777216 false false 212 260 24
Polygon -16777216 false false 264 203 272 223 247 222 239 204
Polygon -14835848 true false 170 272 183 277 186 271 193 276 197 271 197 281 189 279 180 280 174 276
Polygon -14835848 true false 210 268 223 273 226 267 233 272 237 267 237 277 229 275 220 276 214 272
Circle -16777216 true false 174 262 9
Circle -16777216 true false 214 261 9
Polygon -1184463 false false 255 265 260 269 265 265 269 270
Polygon -1184463 true false 129 235 125 234 126 239 121 243 130 242 139 248 136 239 140 234 130 235 130 231
Polygon -1184463 true false 126 269 122 268 123 273 118 277 127 276 136 282 133 273 137 268 127 269 127 265
Rectangle -1 true false 178 256 196 261
Rectangle -1 true false 169 226 187 231
Rectangle -1 true false 118 226 136 231
Rectangle -1 true false 118 256 136 261
Rectangle -1 true false 118 286 136 291
Line -8630108 true 43 178 103 178
Line -8630108 true 192 188 252 188
Line -8630108 true 113 189 173 189
Line -8630108 true 42 187 102 187
Line -8630108 true 115 181 175 181
Polygon -955883 true false 32 272 34 265 42 268 45 264 45 272 43 271 37 274
Polygon -955883 true false 78 271 80 264 88 267 91 263 91 271 89 270 83 273
Circle -955883 true false 41 275 6
Circle -955883 true false 87 273 6
Polygon -16777216 true false 216 219 216 217 210 217 213 213 210 213 213 209 219 213 217 214 222 216 219 218 219 218
Polygon -16777216 true false 254 219 254 217 248 217 251 213 248 213 251 209 257 213 255 214 260 216 257 218 257 218
Circle -1 true false 220 204 6
Circle -1 true false 258 204 6

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

plant shelf
false
0
Polygon -13840069 true false 145 150 154 114 154 106 157 94 158 104 160 104 162 90 167 86 167 98 170 99 171 84 180 81 176 93 179 96 184 81 191 81 198 85 197 92 188 98 188 99 197 96 197 103 185 104 183 105 196 108 191 115 182 111 179 113 188 118 178 121 173 115 172 116 172 121 168 121 166 118 163 118 163 123 159 120 158 115
Polygon -13840069 true false 219 145 228 109 228 101 231 89 232 99 234 99 236 85 241 81 241 93 244 94 245 79 254 76 250 88 253 91 258 76 265 76 272 80 271 87 262 93 262 94 271 91 271 98 259 99 257 100 270 103 265 110 256 106 253 108 262 113 252 116 247 110 246 111 246 116 242 116 240 113 237 113 237 118 233 115 232 110
Polygon -10899396 true false 148 125 144 91 139 88 132 92 124 93 130 82 128 79 120 89 112 88 121 78 120 77 111 84 103 82 114 73 113 71 103 75 99 70 112 67 113 65 102 64 100 57 108 54 115 62 116 53 121 53 123 63 126 64 127 56 135 61 135 71 138 73 140 64 147 66 145 76 147 78 151 74 147 85 148 89 152 126
Polygon -10899396 true false 222 126 218 92 213 89 206 93 198 94 204 83 202 80 194 90 186 89 195 79 194 78 185 85 177 83 188 74 187 72 177 76 173 71 186 68 187 66 176 65 174 58 182 55 189 63 190 54 195 54 197 64 200 65 201 57 209 62 209 72 212 74 214 65 221 67 219 77 221 79 225 75 221 86 222 90 226 127
Polygon -14835848 true false 147 132 142 108 128 103 119 108 121 122 117 128 114 118 112 120 114 131 110 139 107 127 104 129 107 142 102 147 100 134 97 135 98 147 91 150 87 145 91 136 90 134 86 139 84 132 95 127 95 125 86 128 88 119 99 118 100 114 90 114 99 106 107 110 109 108 105 105 111 104 118 103 129 100 144 107 151 132
Polygon -16777216 true false 47 258 136 229 137 238 47 268
Rectangle -16777216 true false 45 255 180 270
Rectangle -16777216 true false 135 150 144 239
Polygon -6459832 true false 243 164 288 149 138 149 108 164
Rectangle -16777216 true false 105 165 240 170
Polygon -16777216 true false 284 151 240 165 240 170 284 156 284 152 284 152
Polygon -6459832 true false 210 210 255 195 105 195 75 210
Polygon -6459832 true false 180 255 225 240 75 240 45 255
Rectangle -1 true false 186 165 204 170
Rectangle -1 true false 129 165 147 170
Rectangle -16777216 true false 75 210 210 215
Rectangle -1 true false 156 210 174 215
Rectangle -1 true false 99 210 117 215
Rectangle -1 true false 126 255 144 260
Rectangle -1 true false 69 255 87 260
Polygon -16777216 true false 224 241 180 255 180 260 224 246 224 242 224 242
Polygon -16777216 true false 254 196 210 210 210 215 254 201 254 197 254 197
Rectangle -16777216 true false 242 166 251 195
Rectangle -16777216 true false 212 211 221 240
Rectangle -16777216 true false 107 166 116 195
Rectangle -16777216 true false 77 211 86 240
Polygon -16777216 true false 180 260 279 226 279 238 180 270
Rectangle -16777216 true false 276 148 285 238
Rectangle -16777216 true false 136 230 285 236
Polygon -7500403 true true 130 173 137 203 157 205 162 173
Polygon -13791810 true false 123 228 124 229 127 250 143 251 148 228
Polygon -13791810 true false 94 228 95 229 98 250 114 251 119 228
Polygon -13791810 true false 180 223 181 224 184 245 200 246 205 223
Polygon -13791810 true false 152 228 153 229 156 250 172 251 177 228
Polygon -955883 true false 130 123 137 158 175 158 179 126
Polygon -14835848 true false 218 125 213 101 199 96 190 101 192 115 188 121 185 111 183 113 185 124 181 132 178 120 175 122 178 135 173 140 171 127 168 128 169 140 162 143 158 138 162 129 161 127 157 132 155 125 166 120 166 118 157 121 159 112 170 111 171 107 161 107 170 99 178 103 180 101 176 98 182 97 189 96 200 93 215 100 222 125
Polygon -955883 true false 199 124 206 159 244 159 248 127
Circle -13840069 true false 179 203 30
Circle -10899396 true false 150 208 30
Circle -13840069 true false 120 207 30
Circle -10899396 true false 92 208 30
Polygon -13791810 true false 66 228 67 229 70 250 86 251 91 228
Circle -13840069 true false 64 205 30
Circle -2674135 true false 157 225 10
Circle -2674135 true false 154 208 10
Circle -2674135 true false 137 215 10
Circle -2674135 true false 124 204 10
Circle -2674135 true false 123 225 10
Circle -2674135 true false 111 212 10
Circle -2674135 true false 96 207 10
Circle -2674135 true false 99 220 10
Circle -2674135 true false 79 203 10
Circle -2674135 true false 72 221 10
Circle -2674135 true false 66 206 10
Circle -2674135 true false 195 206 10
Circle -2674135 true false 192 222 10
Circle -2674135 true false 177 213 10
Circle -2674135 true false 166 213 10
Polygon -5825686 true false 83 218 88 224 90 217
Polygon -5825686 true false 185 208 190 214 192 207
Polygon -5825686 true false 151 219 156 225 158 218
Polygon -5825686 true false 124 218 129 224 131 217
Polygon -5825686 true false 135 208 140 214 142 207
Polygon -5825686 true false 112 225 117 231 119 224
Polygon -5825686 true false 93 231 98 237 100 230
Polygon -5825686 true false 62 220 67 226 69 219
Polygon -10899396 true false 26 96
Polygon -10899396 true false 103 185 103 167 96 158 82 158 76 163 76 171 80 176 89 176 88 167 82 166 81 169 83 171 84 167 88 168 89 175 81 173 79 165 83 160 95 160 102 169 102 183
Polygon -7500403 true true 93 171 100 201 120 203 125 171
Circle -14835848 true false 86 165 4
Circle -14835848 true false 88 172 4
Circle -14835848 true false 80 174 4
Circle -14835848 true false 100 163 4
Circle -14835848 true false 97 157 4
Circle -14835848 true false 91 153 4
Circle -14835848 true false 83 153 4
Circle -14835848 true false 74 153 8
Circle -14835848 true false 72 163 4
Circle -14835848 true false 73 171 4
Polygon -13840069 true false 108 175 108 165 100 161 89 171 87 183 91 194 99 197 110 194 108 188 104 183 98 182 95 187 97 190 101 187 106 189 106 195 99 195 93 191 90 185 92 176 97 169 100 164 105 168 106 175
Polygon -13840069 true false 142 176 142 166 150 162 161 172 163 184 159 195 151 198 140 195 142 189 146 184 152 183 155 188 153 191 149 188 144 190 144 196 151 196 157 192 160 186 158 177 153 170 150 165 145 169 144 176
Polygon -10899396 true false 142 177 142 159 135 150 121 150 115 155 115 163 119 168 128 168 127 159 121 158 120 161 122 163 123 159 127 160 128 167 120 165 118 157 122 152 134 152 141 161 141 175
Polygon -14835848 true false 105 172 106 163 118 160 122 166 122 176 117 186 108 182 114 181 118 178 119 167 114 162
Polygon -14835848 true false 141 173 140 164 128 161 124 167 124 177 129 187 138 183 132 182 128 179 127 168 132 163
Polygon -10899396 true false 187 191 187 173 180 164 166 164 160 169 160 177 164 182 173 182 172 173 166 172 165 175 167 177 168 173 172 174 173 181 165 179 163 171 167 166 179 166 186 175 186 189
Polygon -7500403 true true 170 174 177 204 197 206 202 174
Polygon -13840069 true false 189 175 189 165 197 161 208 171 210 183 206 194 198 197 187 194 189 188 193 183 199 182 202 187 200 190 196 187 191 189 191 195 198 195 204 191 207 185 205 176 200 169 197 164 192 168 191 175
Polygon -14835848 true false 177 161 180 153 190 149 194 155 194 165 189 175 184 173 186 170 190 167 191 156 186 151
Circle -14835848 true false 208 170 4
Circle -14835848 true false 205 167 10
Circle -14835848 true false 150 171 4
Circle -14835848 true false 176 166 4
Circle -14835848 true false 167 165 4
Circle -13840069 true false 193 155 8
Circle -14835848 true false 202 163 4
Circle -14835848 true false 205 190 4
Circle -14835848 true false 210 184 4
Circle -14835848 true false 210 177 4
Circle -14835848 true false 126 150 8
Circle -13840069 true false 136 178 8
Circle -13840069 true false 82 189 8
Circle -14835848 true false 97 175 8
Circle -14835848 true false 181 187 8
Circle -14835848 true false 131 191 8
Circle -14835848 true false 117 184 8
Circle -13840069 true false 167 174 14

prepared food 1
false
0
Circle -1 false false 106 171 37
Circle -1 false false 157 171 37
Polygon -6459832 true false 60 225 75 210 105 195 195 195 225 210 240 225 225 240 195 255 120 255 75 240
Polygon -7500403 true true 198 199 184 213 154 214 154 198
Polygon -7500403 true true 203 204 224 214 231 225 221 236 220 237 186 217
Polygon -7500403 true true 183 220 156 219 156 250 180 250 210 238
Polygon -7500403 true true 102 199 116 213 146 214 146 198
Polygon -7500403 true true 97 204 76 214 69 225 79 236 80 237 114 217
Polygon -7500403 true true 118 220 145 219 145 250 121 250 91 238
Polygon -955883 true false 114 227 115 232 121 230 121 224
Polygon -955883 true false 127 230 130 236 133 234 133 231 130 230 135 224 127 220 125 228
Polygon -955883 true false 112 230 115 236 118 234 118 231 115 230 120 224 112 220 110 228
Polygon -955883 true false 144 236 141 242 138 240 138 237 141 236 136 230 144 226 146 234
Polygon -955883 true false 101 239 104 245 107 243 107 240 104 239 109 233 101 229 99 237
Polygon -955883 true false 118 244 121 250 124 248 124 245 121 244 126 238 118 234 116 242
Polygon -955883 true false 133 243 134 248 140 246 140 240
Polygon -955883 true false 134 222 135 227 141 225 141 219
Polygon -955883 true false 106 228 107 233 113 231 113 225
Polygon -955883 true false 125 244 126 249 132 247 132 241
Polygon -955883 true false 107 241 108 246 114 244 114 238
Polygon -955883 true false 127 239 128 244 134 242 134 236
Polygon -955883 true false 108 237 113 237 112 234 107 233
Polygon -955883 true false 108 237 113 237 112 234 107 233
Polygon -955883 true false 119 224 124 224 123 221 118 220
Polygon -955883 true false 121 235 126 235 125 232 120 231
Polygon -1184463 true false 162 217 162 217 165 222 164 227 157 229 164 232 171 229 171 222
Polygon -1184463 true false 196 226 196 226 193 231 194 236 201 238 194 241 187 238 187 231
Polygon -1184463 true false 178 219 178 219 181 224 180 229 173 231 180 234 187 231 187 224
Polygon -1184463 true false 168 233 168 233 165 238 166 243 173 245 166 248 159 245 159 238
Polygon -1184463 true false 176 229 176 229 179 234 178 239 171 241 178 244 185 241 185 234
Circle -1184463 true false 168 223 10
Circle -1184463 true false 193 231 10
Circle -1184463 true false 178 239 10
Polygon -14835848 true false 76 233 73 230 73 225 77 227 80 223 84 224 84 227 89 229 89 235 83 235 83 239 76 236
Polygon -14835848 true false 102 220 99 217 99 212 103 214 106 210 110 211 110 214 115 216 115 222 109 222 109 226 102 223
Polygon -14835848 true false 91 208 88 205 88 200 92 202 95 198 99 199 99 202 104 204 104 210 98 210 98 214 91 211
Polygon -14835848 true false 92 229 89 226 89 221 93 223 96 219 100 220 100 223 105 225 105 231 99 231 99 235 92 232
Polygon -14835848 true false 78 217 75 214 75 209 79 211 82 207 86 208 86 211 91 213 91 219 85 219 85 223 78 220
Circle -13840069 true false 79 210 8
Circle -13840069 true false 92 202 8
Circle -13840069 true false 106 216 8
Circle -13840069 true false 91 223 8
Circle -13840069 true false 78 228 8
Polygon -1 true false 109 205 112 199 116 203 123 202 124 207 130 208 133 203 137 206 141 204 145 206 146 212 115 212
Line -955883 false 114 207 116 208
Line -955883 false 122 207 122 210
Line -955883 false 119 205 122 205
Line -955883 false 132 210 134 208
Line -955883 false 113 206 113 204
Line -955883 false 140 206 142 209
Line -955883 false 140 210 138 208
Circle -13840069 true false 140 205 4
Circle -13840069 true false 135 206 4
Circle -13840069 true false 131 203 4
Circle -13840069 true false 124 207 4
Circle -13840069 true false 117 207 4
Circle -13840069 true false 111 202 4
Polygon -2674135 true false 154 202 159 198 166 201 167 205 162 208 159 205 157 206
Polygon -2674135 true false 173 206 178 202 185 205 186 209 181 212 178 209 176 210
Polygon -1184463 true false 162 207 167 203 174 206 175 210 170 213 167 210 165 211
Polygon -1184463 true false 179 200 184 196 191 199 192 203 187 206 184 203 182 204
Polygon -14835848 true false 166 200 171 196 178 199 179 203 174 206 171 203 169 204
Polygon -14835848 true false 153 208 158 204 165 207 166 211 161 214 158 211 156 212
Polygon -1 true false 187 216 193 213 197 214 199 211 203 210 207 215 211 217 216 216 219 218 223 218 227 221 229 223 229 225 219 235
Polygon -8630108 false false 198 217 204 214 219 223 208 220 213 224 221 228 227 224 207 220 203 219 206 217 201 215 193 216 200 223 207 223 210 223 218 232 209 226 223 229 200 218 200 218
Line -2064490 false 201 213 205 220
Line -2064490 false 195 215 197 219
Line -2064490 false 191 217 193 215
Line -2064490 false 203 221 210 224
Line -2064490 false 209 219 217 219
Line -2064490 false 217 228 219 222
Line -2064490 false 209 227 215 231
Line -2064490 false 222 220 224 223
Line -2064490 false 223 227 220 229
Line -955883 false 223 225 220 220
Line -955883 false 202 211 197 215
Line -955883 false 215 219 221 219
Line -955883 false 195 220 203 220
Line -955883 false 209 225 212 229
Circle -1 false false 196 208 40
Circle -1 false false 154 221 40
Circle -1 false false 64 208 40
Circle -1 false false 106 221 40
Polygon -16777216 true false 60 225 60 270 75 285 105 300 195 300 225 285 240 270 240 225 225 240 195 255 120 255 75 240
Polygon -1 false false 101 173 127 166 151 165 150 210 150 255 120 255 75 240 60 225 74 199
Polygon -1 false false 199 173 173 166 149 165 150 210 150 255 196 254 225 240 240 225 226 199

prepared food 2
false
0
Circle -1 false false 155 172 42
Circle -1 false false 103 172 42
Polygon -6459832 true false 60 225 75 210 105 195 195 195 225 210 240 225 225 240 195 255 120 255 75 240
Polygon -7500403 true true 198 199 184 213 154 214 154 198
Polygon -7500403 true true 203 204 224 214 231 225 221 236 220 237 186 217
Polygon -7500403 true true 183 220 156 219 156 250 180 250 210 238
Polygon -7500403 true true 102 199 116 213 146 214 146 198
Polygon -7500403 true true 97 204 76 214 69 225 79 236 80 237 114 217
Polygon -7500403 true true 118 220 145 219 145 250 121 250 91 238
Polygon -955883 true false 96 241 117 228 145 228 144 251 122 252
Polygon -1 true false 114 231 114 226 113 225 112 223 114 222 116 224 117 222 119 223 117 227 118 227 117 231
Polygon -1 true false 126 230 126 225 125 224 124 222 126 221 128 223 129 221 131 222 129 226 130 226 129 230
Polygon -1 true false 138 229 138 224 137 223 136 221 138 220 140 222 141 220 143 221 141 225 142 225 141 229
Polygon -6459832 true false 110 235 112 231 119 231 120 236
Polygon -6459832 true false 121 233 123 229 130 229 131 234
Polygon -6459832 true false 133 232 135 228 142 228 143 233
Polygon -1 true false 103 237 103 232 102 231 101 229 103 228 105 230 106 228 108 229 106 233 107 233 106 237
Polygon -1 true false 114 243 114 238 113 237 112 235 114 234 116 236 117 234 119 235 117 239 118 239 117 243
Polygon -1 true false 128 242 128 237 127 236 126 234 128 233 130 235 131 233 133 234 131 238 132 238 131 242
Polygon -1 true false 138 243 138 238 137 237 136 235 138 234 140 236 141 234 143 235 141 239 142 239 141 243
Polygon -6459832 true false 99 239 101 235 108 235 109 240
Polygon -6459832 true false 111 245 113 241 120 241 121 246
Polygon -6459832 true false 124 245 126 241 133 241 134 246
Polygon -6459832 true false 135 246 137 242 144 242 145 247
Polygon -2674135 true false 157 225 188 224 209 238 182 249 155 250 156 225
Polygon -1184463 true false 156 232 156 229 161 228 162 232 167 231 167 230 170 226 170 226 180 225 181 225 181 225 185 228 189 229 194 229 198 229 208 239 181 248 155 250
Circle -6459832 true false 159 234 8
Circle -6459832 true false 172 237 8
Circle -6459832 true false 185 231 8
Circle -6459832 true false 172 228 8
Circle -6459832 true false 194 232 8
Circle -6459832 true false 156 241 8
Polygon -10899396 true false 72 226 78 216 95 211 112 217 80 235
Circle -955883 true false 94 212 6
Circle -955883 true false 90 220 6
Circle -955883 true false 73 219 6
Circle -955883 true false 100 216 6
Circle -955883 true false 80 224 6
Circle -955883 true false 83 213 6
Polygon -6459832 true false 78 218 79 223 82 223 82 217
Polygon -6459832 true false 89 219 98 217 99 223 92 223
Polygon -6459832 true false 81 215 90 213 91 219 84 219
Polygon -6459832 true false 80 225 89 223 90 229 83 229
Polygon -6459832 true false 102 217 103 222 106 222 106 216
Polygon -6459832 true false 93 222 94 227 97 227 97 221
Circle -2064490 true false 123 200 8
Circle -2064490 true false 111 200 8
Circle -2064490 true false 113 205 8
Circle -2064490 true false 133 199 8
Polygon -5825686 true false 106 204 146 204 146 214 114 213
Circle -2064490 true false 136 202 8
Circle -2064490 true false 124 204 8
Circle -2064490 true false 115 201 8
Circle -1184463 true false 111 203 6
Circle -13840069 true false 126 200 6
Circle -1184463 true false 131 207 6
Polygon -14835848 true false 201 206 199 211 201 214 204 216 206 213 206 208
Polygon -14835848 true false 201 225 207 229 209 228 210 224 205 222
Polygon -14835848 true false 193 213 199 216 199 218 199 220 197 222 196 221 194 218 194 214 194 214 194 214
Polygon -14835848 true false 216 227 222 230 222 232 222 234 220 236 219 235 217 232 217 228 217 228 217 228
Polygon -14835848 true false 220 214 226 217 226 219 226 221 224 223 223 222 221 219 221 215 221 215 221 215
Polygon -14835848 true false 209 209 215 212 215 214 215 216 213 218 212 217 210 214 210 210 210 210 210 210
Polygon -14835848 true false 204 214 202 219 204 222 207 224 209 221 209 216
Polygon -14835848 true false 219 219 217 224 219 227 222 229 224 226 224 221
Polygon -14835848 true false 212 222 210 227 212 230 215 232 217 229 217 224
Polygon -14835848 true false 203 210 209 214 211 213 212 209 207 207
Polygon -14835848 true false 212 219 218 223 220 222 221 218 216 216
Circle -1 true false 196 209 6
Circle -1 true false 222 220 6
Circle -1 true false 210 224 6
Circle -1 true false 217 212 6
Circle -1 true false 207 213 6
Circle -1 true false 201 220 6
Circle -955883 true false 197 160 0
Circle -955883 true false 223 221 4
Circle -955883 true false 217 212 4
Circle -955883 true false 213 225 4
Circle -955883 true false 202 220 4
Circle -955883 true false 208 213 4
Circle -955883 true false 197 210 4
Polygon -1 true false 154 206 157 204 158 205 159 201 161 200 165 203 166 201 169 202 169 205 174 205 174 203 176 202 180 206 182 203 186 205 189 204 189 202 193 204 183 213 153 214
Line -13840069 false 162 210 164 211
Line -13840069 false 165 205 163 206
Line -13840069 false 158 207 158 209
Line -13840069 false 173 210 177 211
Line -13840069 false 177 208 177 206
Line -13840069 false 170 208 172 207
Line -13840069 false 187 206 185 208
Line -13840069 false 182 209 181 207
Line -13840069 false 163 204 161 204
Line -13840069 false 168 211 168 210
Line -5825686 false 156 207 160 208
Line -5825686 false 167 209 166 206
Line -5825686 false 161 203 162 203
Line -5825686 false 172 211 173 210
Line -5825686 false 178 210 180 208
Line -5825686 false 174 206 175 206
Line -5825686 false 184 207 185 208
Line -5825686 false 189 205 189 206
Circle -1 false false 194 207 42
Circle -1 false false 64 207 42
Circle -1 false false 152 220 42
Circle -1 false false 106 220 42
Polygon -16777216 true false 60 225 60 270 75 285 105 300 195 300 225 285 240 270 240 225 225 240 195 255 120 255 75 240
Circle -13840069 true false 138 205 6
Polygon -1 false false 101 173 127 166 151 165 150 210 150 255 120 255 75 240 60 225 74 199
Polygon -1 false false 199 173 173 166 149 165 150 210 150 255 195 255 225 240 240 225 226 199

sanitiser
false
1
Rectangle -16777216 true false 136 179 146 300
Polygon -16777216 true false 123 299 131 288 161 288 168 300
Polygon -16777216 true false 143 284 156 282 155 278 143 279
Polygon -1 true false 145 190 149 190 149 194 154 197 155 208 156 216 154 219 147 221 143 221 142 203 143 199
Line -16777216 false 145 191 164 189
Line -16777216 false 163 190 165 195
Circle -13791810 true false 143 201 12

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

starch shelf
false
0
Polygon -16777216 true false 0 270 45 285 45 300 0 285 0 270
Rectangle -16777216 true false 45 285 300 300
Rectangle -16777216 true false 121 181 130 285
Rectangle -16777216 true false 0 181 9 285
Rectangle -16777216 true false 246 181 255 285
Polygon -6459832 true false 45 195 0 180 255 180 300 195
Rectangle -16777216 true false 45 195 300 200
Polygon -16777216 true false 1 181 45 195 45 200 1 186 1 182 1 182
Polygon -6459832 true false 45 241 0 226 255 226 300 241
Polygon -6459832 true false 45 285 0 270 255 270 300 285
Rectangle -1 true false 81 195 99 200
Rectangle -16777216 true false 45 240 300 245
Rectangle -1 true false 66 240 84 245
Rectangle -1 true false 108 240 126 245
Rectangle -1 true false 192 240 210 245
Rectangle -16777216 true false 45 285 300 290
Rectangle -1 true false 66 285 84 290
Rectangle -1 true false 108 285 126 290
Rectangle -1 true false 192 285 210 290
Polygon -16777216 true false 1 271 45 285 45 290 1 276 1 272 1 272
Polygon -16777216 true false 1 226 45 240 45 245 1 231 1 227 1 227
Rectangle -16777216 true false 291 196 300 300
Rectangle -1 true false 237 285 255 290
Rectangle -1 true false 237 195 255 200
Polygon -1 true false 202 264 227 283 228 279 233 282 281 282 280 272 286 277 253 258 245 257 209 260 206 263
Polygon -16777216 false false 202 264 206 264 207 261 250 257 280 273 280 281 233 283 227 278 227 282
Rectangle -1 true false 237 240 255 245
Polygon -14835848 true false 210 270 216 265 258 262 273 270 223 272 221 276
Polygon -1 true false 202 254 227 273 228 269 233 272 281 272 280 262 286 267 253 248 245 247 209 250 206 253
Polygon -16777216 false false 201 252 205 252 206 249 249 245 279 261 279 269 232 271 226 266 226 270
Polygon -14835848 true false 209 259 215 254 257 251 272 259 222 261 220 265
Polygon -1 true false 133 265 158 284 159 280 164 283 212 283 211 273 217 278 184 259 176 258 140 261 137 264
Polygon -16777216 false false 131 264 135 264 136 261 179 257 209 273 209 281 162 283 156 278 156 282
Polygon -13791810 true false 138 270 144 265 186 262 201 270 151 272 149 276
Polygon -1 true false 131 255 156 274 157 270 162 273 210 273 209 263 215 268 182 249 174 248 138 251 135 254
Polygon -16777216 false false 132 255 136 255 137 252 180 248 210 264 210 272 163 274 157 269 157 273
Polygon -13791810 true false 139 260 145 255 187 252 202 260 152 262 150 266
Polygon -6459832 true false 64 261 89 280 90 276 95 279 143 279 142 269 148 274 115 255 107 254 71 257 68 260
Polygon -16777216 false false 63 261 67 261 68 258 111 254 141 270 141 278 94 280 88 275 88 279
Polygon -5825686 true false 70 267 76 262 118 259 133 267 83 269 81 273
Polygon -6459832 true false 64 253 89 272 90 268 95 271 143 271 142 261 148 266 115 247 107 246 71 249 68 252
Polygon -16777216 false false 65 253 69 253 70 250 113 246 143 262 143 270 96 272 90 267 90 271
Polygon -5825686 true false 72 258 78 253 120 250 135 258 85 260 83 264
Polygon -6459832 true false 12 263 37 282 38 278 43 281 91 281 90 271 96 276 63 257 55 256 19 259 16 262
Polygon -16777216 false false 10 262 14 262 15 259 58 255 88 271 88 279 41 281 35 276 35 280
Polygon -5825686 true false 18 268 24 263 66 260 81 268 31 270 29 274
Polygon -6459832 true false 10 252 35 271 36 267 41 270 89 270 88 260 94 265 61 246 53 245 17 248 14 251
Polygon -16777216 false false 10 251 14 251 15 248 58 244 88 260 88 268 41 270 35 265 35 269
Polygon -5825686 true false 17 257 23 252 65 249 80 257 30 259 28 263
Polygon -16777216 true false 232 202 226 208 227 225 232 230 259 231 261 222 258 200
Polygon -955883 false false 230 205 224 209 225 227 234 230 258 230 259 213 257 207 255 200 230 204 233 209 232 227 226 225 226 209
Polygon -955883 false false 237 211 237 226 254 226 254 212
Polygon -1184463 true false 208 214 207 222 212 219 216 223 216 213 211 217
Polygon -1184463 true false 248 211 247 219 252 216 256 220 256 210 251 214
Polygon -1184463 true false 242 219 241 227 246 224 250 228 250 218 245 222
Polygon -1184463 true false 239 213 238 221 243 218 247 222 247 212 242 216
Polygon -16777216 true false 200 203 194 209 195 226 200 231 227 232 229 223 226 201
Polygon -955883 false false 200 206 194 210 195 228 204 231 228 231 229 214 227 208 225 201 200 205 203 210 202 228 196 226 196 210
Polygon -955883 false false 207 212 207 227 224 227 224 213
Polygon -1184463 true false 218 217 217 225 222 222 226 226 226 216 221 220
Polygon -1184463 true false 208 219 207 227 212 224 216 228 216 218 211 222
Polygon -1184463 true false 212 211 211 219 216 216 220 220 220 210 215 214
Polygon -16777216 true false 226 210 220 216 221 233 226 238 253 239 255 230 252 208
Polygon -955883 false false 227 212 221 216 222 234 231 237 255 237 256 220 254 214 252 207 227 211 230 216 229 234 223 232 223 216
Polygon -955883 false false 233 217 233 232 250 232 250 218
Polygon -1184463 true false 236 225 235 233 240 230 244 234 244 224 239 228
Polygon -1184463 true false 242 220 241 228 246 225 250 229 250 219 245 223
Polygon -1184463 true false 235 218 234 226 239 223 243 227 243 217 238 221
Polygon -16777216 true false 228 158 222 164 223 181 228 186 255 187 257 178 254 156
Polygon -13840069 false false 226 160 220 164 221 182 230 185 254 185 255 168 253 162 251 155 226 159 229 164 228 182 222 180 222 164
Polygon -13840069 false false 233 166 233 181 250 181 250 167
Polygon -1184463 true false 251 167 247 168 247 179 251 175
Polygon -1184463 true false 246 163 242 164 242 175 246 171
Polygon -1184463 true false 237 168 233 171 244 184 245 179
Polygon -16777216 true false 193 156 187 162 188 179 193 184 220 185 222 176 219 154
Polygon -13840069 false false 192 158 186 162 187 180 196 183 220 183 221 166 219 160 217 153 192 157 195 162 194 180 188 178 188 162
Polygon -13840069 false false 199 163 199 178 216 178 216 164
Polygon -1184463 true false 203 164 199 167 210 180 211 175
Polygon -1184463 true false 215 165 211 166 211 177 215 173
Polygon -1184463 true false 212 159 208 160 208 171 212 167
Polygon -16777216 true false 214 164 208 170 209 187 214 192 241 193 243 184 240 162
Polygon -13840069 false false 212 167 206 171 207 189 216 192 240 192 241 175 239 169 237 162 212 166 215 171 214 189 208 187 208 171
Polygon -13840069 false false 220 173 220 188 237 188 237 174
Polygon -1184463 true false 223 173 219 176 230 189 231 184
Polygon -1184463 true false 237 174 233 175 233 186 237 182
Polygon -1184463 true false 233 168 229 169 229 180 233 176
Polygon -16777216 true false 257 162 251 168 252 185 257 190 284 191 286 182 283 160
Polygon -13840069 false false 257 164 251 168 252 186 261 189 285 189 286 172 284 166 282 159 257 163 260 168 259 186 253 184 253 168
Polygon -13840069 false false 264 170 264 185 281 185 281 171
Polygon -1184463 true false 268 170 264 173 275 186 276 181
Polygon -1184463 true false 282 172 278 173 278 184 282 180
Polygon -1184463 true false 278 167 274 168 274 179 278 175
Polygon -2674135 true false 135 152 135 181 155 194 194 192 195 177 176 151
Polygon -16777216 true false 139 155 157 180 195 179 176 154 176 177 174 154
Polygon -1184463 false false 142 139 143 170 144 138 146 166 148 144 150 175 152 137 151 185 147 141 145 177
Polygon -2674135 false false 138 138 139 179 152 183 151 136
Polygon -1184463 false false 157 141 158 172 159 140 161 168 163 146 165 177 167 139 166 187 162 143 160 179
Polygon -1184463 false false 173 144 174 175 175 143 177 171 179 149 181 180 183 142 182 190 178 146 176 182
Polygon -2674135 false false 155 141 156 182 169 186 168 139
Polygon -2674135 false false 171 144 172 185 185 189 184 142
Polygon -16777216 true false 133 153 133 181 154 192 193 191 193 181 155 180
Rectangle -1 true false 162 195 180 200
Polygon -16777216 true false 109 147 109 147 111 152 107 154 103 163 105 182 105 183 128 183 132 168 131 155 127 151 128 146
Polygon -2674135 false false 112 154 108 157 115 157 116 165 111 163 111 158 121 159 121 154 116 155 119 172 121 171 121 165 131 165 126 158 121 162 124 155 112 170 110 163 118 173 113 174 128 167 124 179 122 176 118 178 111 171 109 161 126 166 121 174 113 179 106 173 106 166 112 173 108 163
Polygon -16777216 true false 35 150 35 150 37 155 33 157 29 166 31 185 31 186 54 186 58 171 57 158 53 154 54 149
Polygon -16777216 true false 72 149 72 149 74 154 70 156 66 165 68 184 68 185 91 185 95 170 94 157 90 153 91 148
Polygon -10899396 false false 76 156 72 159 79 159 80 167 75 165 75 160 85 161 85 156 80 157 83 174 85 173 85 167 95 167 90 160 85 164 88 157 76 172 74 165 82 175 77 176 92 169 88 181 86 178 82 180 75 173 73 163 90 168 85 176 77 181 70 175 70 168 76 175 72 165
Polygon -16777216 false false 71 149 74 152 70 156 66 160 67 184 88 183 93 169 93 155 89 151 89 149
Polygon -1184463 false false 38 159 34 162 41 162 42 170 37 168 37 163 47 164 47 159 42 160 45 177 47 176 47 170 57 170 52 163 47 167 50 160 38 175 36 168 44 178 39 179 54 172 50 184 48 181 44 183 37 176 35 166 52 171 47 179 39 184 32 178 32 171 38 178 34 168
Polygon -16777216 true false 56 156 56 156 58 161 54 163 50 172 52 191 52 192 75 192 79 177 78 164 74 160 75 155
Polygon -2674135 false false 58 164 54 167 61 167 62 175 57 173 57 168 67 169 67 164 62 165 65 182 67 181 67 175 77 175 72 168 67 172 70 165 58 180 56 173 64 183 59 184 74 177 70 189 68 186 64 188 57 181 55 171 72 176 67 184 59 189 52 183 52 176 58 183 54 173
Polygon -16777216 true false 100 156 100 156 102 161 98 163 94 172 96 191 96 192 119 192 123 177 122 164 118 160 119 155
Polygon -1184463 false false 102 163 98 166 105 166 106 174 101 172 101 167 111 168 111 163 106 164 109 181 111 180 111 174 121 174 116 167 111 171 114 164 102 179 100 172 108 182 103 183 118 176 114 188 112 185 108 187 101 180 99 170 116 175 111 183 103 188 96 182 96 175 102 182 98 172
Polygon -7500403 true true 33 201 33 201 35 206 31 208 27 217 29 236 29 237 52 237 56 222 55 209 51 205 52 200
Polygon -7500403 true true 67 203 67 203 69 208 65 210 61 219 63 238 63 239 86 239 90 224 89 211 85 207 86 202
Circle -6459832 true false 63 226 4
Circle -6459832 true false 41 230 4
Circle -6459832 true false 33 230 4
Circle -6459832 true false 48 221 4
Circle -6459832 true false 46 228 4
Circle -6459832 true false 41 222 4
Circle -6459832 true false 31 226 4
Circle -6459832 true false 37 228 4
Circle -6459832 true false 39 219 4
Circle -6459832 true false 33 221 4
Circle -6459832 true false 31 216 4
Circle -6459832 true false 45 205 4
Circle -6459832 true false 48 209 4
Circle -6459832 true false 40 217 4
Circle -6459832 true false 45 216 4
Circle -6459832 true false 35 215 4
Circle -6459832 true false 39 212 4
Circle -6459832 true false 42 209 4
Circle -6459832 true false 36 210 4
Circle -6459832 true false 37 206 4
Circle -6459832 true false 31 211 4
Circle -6459832 true false 70 232 4
Circle -6459832 true false 67 228 4
Circle -6459832 true false 82 218 4
Circle -6459832 true false 80 213 4
Circle -6459832 true false 79 224 4
Circle -6459832 true false 74 230 4
Circle -6459832 true false 68 225 4
Circle -6459832 true false 74 224 4
Circle -6459832 true false 64 221 4
Circle -6459832 true false 69 220 4
Circle -6459832 true false 74 216 4
Circle -6459832 true false 77 211 4
Circle -6459832 true false 69 212 4
Circle -6459832 true false 65 215 4
Circle -6459832 true false 70 209 4
Circle -6459832 true false 77 206 4
Circle -6459832 true false 82 228 4
Circle -6459832 true false 79 232 4
Rectangle -13345367 true false 109 202 154 217
Rectangle -13345367 true false 138 218 183 233
Rectangle -13345367 true false 91 219 136 234
Circle -1184463 true false 135 210 4
Circle -1184463 true false 122 221 4
Circle -1184463 true false 117 225 4
Circle -1184463 true false 141 209 4
Circle -1184463 true false 139 202 4
Circle -1184463 true false 126 212 4
Circle -1184463 true false 112 220 4
Circle -1184463 true false 135 206 4
Circle -1184463 true false 130 209 4
Circle -1184463 true false 129 203 4
Circle -1184463 true false 125 208 4
Circle -1184463 true false 118 208 4
Circle -1184463 true false 120 203 4
Circle -1184463 true false 103 223 4
Circle -1184463 true false 162 224 4
Circle -1184463 true false 155 226 4
Circle -1184463 true false 158 219 4
Circle -1184463 true false 146 224 4
Circle -1184463 true false 152 221 4
Circle -1184463 true false 151 227 4
Circle -1184463 true false 146 219 4
Circle -1184463 true false 107 218 4
Circle -1184463 true false 123 226 4
Circle -1184463 true false 113 227 4
Circle -1184463 true false 105 228 4
Circle -1184463 true false 99 219 4
Circle -1184463 true false 100 227 4
Circle -1184463 true false 109 225 4
Circle -1184463 true false 162 224 4
Circle -1184463 true false 167 226 4
Circle -1184463 true false 171 220 4
Circle -1184463 true false 171 225 4
Circle -1184463 true false 165 220 4
Rectangle -16777216 true false 45 196 54 300
Rectangle -16777216 true false 165 196 174 300
Polygon -16777216 false false 32 201 35 204 31 208 27 212 28 236 49 235 54 221 54 207 50 203 50 201
Polygon -16777216 false false 67 203 70 206 66 210 62 214 63 238 84 237 89 223 89 209 85 205 85 203

sweet fridge
false
9
Polygon -16777216 true false 4 18 47 3 46 208 3 226
Rectangle -16777216 true false 47 46 54 210
Polygon -16777216 true false 298 269 249 285 249 300 299 283 294 270
Polygon -14835848 true false 255 195 300 165 45 90 0 120
Polygon -16777216 true false 295 185 251 199 251 204 295 190 295 186 295 186
Polygon -14835848 true false 255 240 300 210 45 135 0 165
Polygon -14835848 true false 255 285 300 255 45 180 0 210
Polygon -16777216 true false 290 272 246 286 246 291 290 277 290 273 290 273
Polygon -16777216 true false 295 231 251 245 251 250 295 236 295 232 295 232
Rectangle -16777216 true false 0 30 9 225
Polygon -14835848 true false 255 150 300 120 45 45 0 75
Polygon -16777216 true false 294 139 250 153 250 158 294 144 294 140 294 140
Line -16777216 false 45 45 300 120
Polygon -16777216 true false 2 17 5 50 260 125 261 93
Polygon -16777216 true false 0 210 0 225 255 300 255 285
Polygon -16777216 true false 2 123 0 119 252 193 254 197
Polygon -16777216 true false 2 168 0 164 252 238 254 242
Polygon -16777216 true false 2 213 0 209 252 283 254 287
Rectangle -16777216 true false 255 150 255 300
Rectangle -16777216 true false 251 90 258 284
Polygon -16777216 true false 2 33 0 29 252 103 254 107
Polygon -16777216 true false 296 77 252 91 252 96 296 82 296 78 296 78
Polygon -16777216 true false 256 91 299 76 298 281 255 299
Polygon -7500403 true false 1 16 46 2 299 75 251 90
Polygon -1 false false 23 104 26 118 31 122 39 122 45 119 45 101 41 106 35 108 28 107
Polygon -1 false false 25 103 28 97 35 95 42 98 45 101 36 108 29 106
Circle -5825686 true false 25 107 8
Circle -5825686 true false 34 98 8
Circle -5825686 true false 27 99 8
Circle -5825686 true false 37 108 8
Circle -5825686 true false 31 114 8
Polygon -1 false false 48 102 51 116 56 120 64 120 70 117 70 99 66 104 60 106 53 105
Polygon -1 false false 50 100 53 94 60 92 67 95 70 98 61 105 54 103
Polygon -16777216 true false 2 78 0 74 252 148 254 152
Line -6459832 false 252 88 252 297
Circle -5825686 true false 51 96 8
Circle -5825686 true false 55 111 8
Circle -5825686 true false 61 105 8
Circle -5825686 true false 50 106 8
Circle -5825686 true false 59 97 8
Polygon -1 false false 55 116 58 130 63 134 71 134 77 131 77 113 73 118 67 120 60 119
Polygon -1 false false 57 114 60 108 67 106 74 109 77 112 68 119 61 117
Circle -5825686 true false 59 112 8
Circle -5825686 true false 63 126 8
Circle -5825686 true false 66 119 8
Circle -5825686 true false 57 121 8
Circle -5825686 true false 67 111 8
Polygon -1 false false 16 147 19 161 24 165 32 165 38 162 38 144 34 149 28 151 21 150
Polygon -1 false false 17 144 20 138 27 136 34 139 37 142 28 149 21 147
Circle -13345367 true false 19 141 7
Circle -13345367 true false 51 139 7
Circle -13345367 true false 19 158 7
Circle -13345367 true false 31 156 7
Circle -13345367 true false 25 156 7
Circle -13345367 true false 28 148 7
Circle -13345367 true false 19 150 7
Circle -13345367 true false 27 140 7
Polygon -1 false false 40 144 43 158 48 162 56 162 62 159 62 141 58 146 52 148 45 147
Polygon -1 false false 41 144 44 138 51 136 58 139 61 142 52 149 45 147
Circle -13345367 true false 44 140 7
Circle -13345367 true false 55 146 7
Circle -13345367 true false 50 148 7
Circle -13345367 true false 48 154 7
Circle -13345367 true false 43 148 7
Circle -13345367 true false 54 154 7
Polygon -1 false false 47 156 50 170 55 174 63 174 69 171 69 153 65 158 59 160 52 159
Polygon -1 false false 49 156 52 150 59 148 66 151 69 154 60 161 53 159
Circle -13345367 true false 50 166 7
Circle -13345367 true false 57 167 7
Circle -13345367 true false 60 159 7
Circle -13345367 true false 60 152 7
Circle -13345367 true false 52 150 7
Circle -13345367 true false 51 159 7
Circle -13345367 true false 60 164 7
Polygon -6459832 true false 88 129 93 139 121 146 149 131 153 124 115 115
Polygon -2674135 true false 108 128 104 122 109 118 118 119 117 125 112 132
Polygon -2674135 true false 132 130 128 124 133 120 142 121 141 127 136 134
Polygon -2674135 true false 97 134 93 128 98 124 107 125 106 131 101 138
Polygon -2674135 true false 111 139 107 133 112 129 121 130 120 136 115 143
Polygon -2674135 true false 119 127 115 121 120 117 129 118 128 124 123 131
Polygon -16777216 true false 88 129 93 139 120 145 149 131 151 124 117 137
Polygon -10899396 true false 110 121 108 124 111 125 112 120 120 119 117 114 113 120 113 115 111 117 114 117 104 117 104 120
Polygon -10899396 true false 110 121 108 124 111 125 112 120 120 119 117 114 113 120 113 115 111 117 114 117 104 117 104 120
Polygon -10899396 true false 114 130 112 133 115 134 116 129 124 128 121 123 117 129 117 124 115 126 118 126 108 126 108 129
Polygon -10899396 true false 98 128 96 131 99 132 100 127 108 126 105 121 101 127 101 122 99 124 102 124 92 124 92 127
Polygon -10899396 true false 134 123 132 126 135 127 136 122 144 121 141 116 137 122 137 117 135 119 138 119 128 119 128 122
Polygon -10899396 true false 121 124 119 127 122 128 123 123 131 122 128 117 124 123 124 118 122 120 125 120 115 120 115 123
Polygon -6459832 true false 130 142 135 152 163 159 191 144 195 137 157 128
Polygon -2674135 true false 139 149 135 143 140 139 149 140 148 146 143 153
Polygon -2674135 true false 172 146 168 140 173 136 182 137 181 143 176 150
Polygon -2674135 true false 162 139 158 133 163 129 172 130 171 136 166 143
Polygon -2674135 true false 150 140 146 134 151 130 160 131 159 137 154 144
Polygon -2674135 true false 154 152 150 146 155 142 164 143 163 149 158 156
Polygon -10899396 true false 153 135 151 138 154 139 155 134 163 133 160 128 156 134 156 129 154 131 157 131 147 131 147 134
Polygon -10899396 true false 173 138 171 141 174 142 175 137 183 136 180 131 176 137 176 132 174 134 177 134 167 134 167 137
Polygon -10899396 true false 153 145 151 148 154 149 155 144 163 143 160 138 156 144 156 139 154 141 157 141 147 141 147 144
Polygon -10899396 true false 143 141 141 144 144 145 145 140 153 139 150 134 146 140 146 135 144 137 147 137 137 137 137 140
Polygon -10899396 true false 165 132 163 135 166 136 167 131 175 130 172 125 168 131 168 126 166 128 169 128 159 128 159 131
Polygon -16777216 true false 131 142 136 152 163 158 192 144 194 137 160 150
Polygon -1 false false 75 161 94 166 106 160 105 178 95 185 76 177 77 161 89 154 107 159 95 166
Polygon -1184463 true false 83 174 92 158 98 164 87 177
Polygon -1184463 true false 99 178 97 169 89 178 97 182
Polygon -1184463 true false 83 168 86 160 80 164 80 169
Polygon -1184463 true false 104 177 100 170 104 167 106 170
Polygon -1184463 true false 104 166 99 161 104 161
Polygon -1 false false 104 169 123 174 135 168 134 186 124 193 105 185 106 169 118 162 136 167 124 174
Polygon -1184463 true false 111 181 120 165 126 171 115 184
Polygon -1184463 true false 111 176 114 168 108 172 108 177
Polygon -1184463 true false 131 176 126 171 131 171
Polygon -1184463 true false 126 186 124 177 116 186 124 190
Polygon -1184463 true false 130 187 126 180 130 177 132 180
Polygon -1 false false 128 176 147 181 159 175 158 193 148 200 129 192 130 176 142 169 160 174 148 181
Polygon -1184463 true false 136 190 145 174 151 180 140 193
Polygon -1184463 true false 135 187 138 179 132 183 132 188
Polygon -1184463 true false 155 179 150 174 155 174
Polygon -1184463 true false 151 195 149 186 141 195 149 199
Polygon -1184463 true false 153 192 149 185 153 182 155 185
Polygon -6459832 true false 18 71 23 81 51 88 79 72 80 73 40 59
Circle -955883 true false 24 68 13
Circle -955883 true false 49 64 13
Circle -955883 true false 40 72 13
Circle -955883 true false 36 61 13
Polygon -6459832 true false 64 83 69 93 97 100 125 84 126 85 86 73
Circle -955883 true false 72 79 13
Circle -955883 true false 86 82 13
Circle -955883 true false 99 79 13
Circle -955883 true false 85 75 13
Polygon -16777216 true false 64 83 69 93 96 99 125 85 127 78 93 91
Polygon -1 true false 26 198 23 198 20 200 18 202 19 206 25 210 31 211 41 213 54 213 65 210 69 206 68 204 66 201 62 198 57 197 46 197 36 196
Polygon -6459832 true false 24 203 34 208 47 212 56 211 63 206 62 192 55 187 37 185 27 189
Polygon -1 true false 80 212 77 212 74 214 72 216 73 220 79 224 85 225 95 227 108 227 119 224 123 220 122 218 120 215 116 212 111 211 100 211 90 210
Polygon -6459832 true false 77 217 87 222 100 226 109 225 116 220 115 206 108 201 90 199 80 203
Polygon -1 true false 133 229 130 229 127 231 125 233 126 237 132 241 138 242 148 244 161 244 172 241 176 237 175 235 173 232 169 229 164 228 153 228 143 227
Polygon -6459832 true false 130 233 140 238 153 242 162 241 169 236 168 222 161 217 143 215 133 219
Polygon -1 true false 170 197 166 198 165 201 169 207 179 210 188 210 195 207 197 201 193 196 184 195 175 196
Polygon -2064490 true false 170 200 170 186 176 182 184 182 193 186 194 191 193 203 188 207 179 207 171 203
Polygon -1 true false 208 207 204 208 203 211 207 217 217 220 226 220 233 217 235 211 231 206 222 205 213 206
Polygon -2064490 true false 207 211 207 197 213 193 221 193 230 197 231 202 230 214 225 218 216 218 208 214
Polygon -1184463 true false 184 231 198 227 198 231 205 238 204 256 192 261 181 254 182 236 185 235
Polygon -1 true false 181 240 194 247 204 241 204 250 194 253 182 248
Circle -2674135 true false 194 243 6
Line -13840069 false 189 244 191 246
Line -13840069 false 195 249 198 247
Line -13840069 false 198 242 200 246
Polygon -1184463 true false 212 240 226 236 226 240 233 247 232 265 220 270 209 263 210 245 213 244
Polygon -1 true false 210 248 223 255 233 249 233 258 223 261 211 256
Circle -2674135 true false 223 252 6
Line -13840069 false 218 257 222 258
Line -13840069 false 225 252 223 256
Line -13840069 false 231 252 232 255
Polygon -13791810 true true 207 152 198 155 195 161 198 166 210 170 230 170 236 167 237 159 234 155 227 152 219 152
Polygon -7500403 true false 197 155 194 160 195 163 197 167 199 171 216 176 231 175 237 170 239 163 238 160 235 167 230 170 210 170 203 168 197 165 196 162
Line -1184463 false 41 62 39 71
Line -1184463 false 52 66 51 73
Line -1184463 false 45 72 44 79
Line -1184463 false 30 67 29 74
Line -1184463 false 91 83 90 90
Line -1184463 false 103 80 102 87
Line -1184463 false 90 76 89 83
Line -1184463 false 77 79 76 86
Polygon -16777216 true false 18 71 23 81 50 87 79 73 81 66 47 79
Line -6459832 false 206 155 210 158
Line -6459832 false 201 164 204 165
Line -6459832 false 221 168 219 165
Line -6459832 false 222 154 221 159
Line -6459832 false 234 162 230 162
Circle -1 true false 27 186 6
Circle -1 true false 56 189 6
Circle -16777216 true false 131 215 6
Circle -1 true false 210 205 6
Circle -2674135 true false 78 201 6
Circle -1 true false 31 190 6
Circle -1 true false 39 192 6
Circle -1 true false 48 192 6
Circle -1 true false 53 185 6
Circle -1 true false 44 183 6
Circle -1 true false 35 184 6
Polygon -1184463 false false 27 195 30 198 36 201 42 202 51 202 58 202 60 199 60 201 56 204 47 205 40 205 33 202 29 199 27 196
Circle -2674135 true false 104 200 6
Circle -2674135 true false 109 205 6
Circle -2674135 true false 100 207 6
Circle -2674135 true false 96 198 6
Circle -2674135 true false 91 207 6
Circle -2674135 true false 86 197 6
Circle -2674135 true false 83 206 6
Polygon -2064490 false false 80 210 83 213 89 216 95 217 104 217 111 217 113 214 113 216 109 219 100 220 93 220 86 217 82 214 80 211
Polygon -16777216 false false 133 226 136 229 142 232 148 233 157 233 164 233 166 230 166 232 162 235 153 236 146 236 139 233 135 230 133 227
Circle -16777216 true false 161 218 6
Circle -16777216 true false 154 223 6
Circle -16777216 true false 155 214 6
Circle -16777216 true false 145 223 6
Circle -16777216 true false 147 212 6
Circle -16777216 true false 137 220 6
Circle -16777216 true false 139 212 6
Polygon -13840069 true false 183 205 185 202 185 198 181 201
Polygon -13840069 true false 180 206 178 203 178 199 182 202
Polygon -2674135 false false 170 186 171 190 181 194 188 191 192 187 187 183 178 182
Polygon -2674135 false false 207 196 208 200 218 204 225 201 229 197 224 193 215 192
Polygon -13840069 true false 215 217 213 214 213 210 217 213
Polygon -13840069 true false 217 217 219 214 219 210 215 213
Circle -1 true false 175 194 6
Line -1 false 214 199 214 196
Line -1 false 217 199 219 196
Line -1 false 220 201 224 200
Line -1 false 176 188 176 185
Line -1 false 179 189 181 186
Line -1 false 182 190 186 189
Polygon -1 false false 120 105 118 93 124 88 155 95 158 104 152 115
Circle -10899396 true false 122 91 15
Circle -10899396 true false 138 96 15
Polygon -1 false false 164 118 162 106 168 101 199 108 202 117 196 128
Circle -10899396 true false 167 105 15
Circle -10899396 true false 184 109 15
Polygon -1 false false 206 130 204 118 210 113 241 120 244 129 238 140
Circle -10899396 true false 208 117 15
Circle -10899396 true false 224 121 15
Polygon -1 false false 6 51 5 208 77 229 81 72
Polygon -1 false false 86 75 83 231 163 257 165 98
Polygon -1 false false 171 100 168 256 248 282 250 123
Line -1 false 41 111 23 170
Line -1 false 63 81 22 205
Line -1 false 50 141 37 177
Circle -1 false false 62 146 11
Line -1 false 110 138 92 197
Line -1 false 132 106 91 230
Line -1 false 117 170 104 206
Circle -1 false false 150 172 11
Line -1 false 195 147 177 206
Line -1 false 218 118 177 242
Line -1 false 204 183 191 219
Circle -1 false false 234 196 11

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

till
false
0
Circle -1 true false 152 143 9
Polygon -16777216 true false 0 165
Polygon -6459832 true false 0 165 45 135 255 135 300 165
Line -16777216 false 120 270 120 270
Polygon -16777216 true false 105 165 105 285 120 270 180 270 195 285 195 165 180 150 120 150
Rectangle -7500403 true true 195 165 300 285
Rectangle -7500403 true true 0 165 105 285
Line -6459832 false 180 150 180 270
Line -6459832 false 120 150 120 270
Polygon -16777216 true false 22 90 35 109 112 95 97 75
Polygon -14835848 true false 35 110 41 133 115 118 110 95
Polygon -16777216 true false 40 134 116 119 130 135 50 150
Polygon -16777216 true false 48 150 48 161 127 147 127 137
Line -6459832 false 47 151 127 136
Line -16777216 false 92 99 97 119
Line -16777216 false 36 119 94 107
Line -16777216 false 37 112 60 107
Line -16777216 false 40 115 55 112
Circle -16777216 true false 42 126 4
Polygon -7500403 true true 22 90 22 151 47 160 48 150 41 134 35 109
Polygon -6459832 true false 46 135 103 124 110 136 51 147
Line -16777216 false 50 134 56 148
Line -16777216 false 55 133 60 146
Line -16777216 false 59 132 64 145
Line -16777216 false 64 132 68 144
Line -16777216 false 68 131 73 144
Line -16777216 false 73 130 77 142
Line -16777216 false 77 128 82 142
Line -16777216 false 82 128 87 141
Line -16777216 false 86 126 91 139
Line -16777216 false 100 124 106 136
Line -16777216 false 91 126 96 139
Line -16777216 false 95 124 101 138
Line -16777216 false 48 138 104 127
Line -16777216 false 49 142 110 130
Polygon -16777216 true false 11 137 29 135 37 146 46 155 27 162 19 151
Polygon -14835848 true false 16 139 20 146 31 143 26 137
Polygon -6459832 true false 22 148 33 145 40 151 28 154
Polygon -6459832 true false 78 149 79 151 99 147 99 146
Circle -6459832 true false 68 149 4
Polygon -7500403 true true 12 139 12 149 24 167 42 159 45 154 26 161 19 151
Line -16777216 false 22 150 34 146
Line -16777216 false 25 152 36 149
Line -16777216 false 27 147 34 155
Line -16777216 false 30 146 37 154
Rectangle -16777216 true false 0 165 105 180
Rectangle -16777216 true false 195 165 300 180
Rectangle -13840069 true false 15 285 135 270
Rectangle -16777216 true false 195 270 300 285
Rectangle -16777216 true false 0 270 105 285
Line -6459832 false 195 165 195 285
Line -6459832 false 105 165 105 285
Rectangle -16777216 true false 255 15 270 150
Rectangle -14835848 true false 270 15 300 45
Rectangle -16777216 true false 282 20 289 39

till 2
false
0
Circle -1 true false 152 143 9
Polygon -16777216 true false 0 165
Polygon -6459832 true false 0 165 45 135 255 135 300 165
Line -16777216 false 120 270 120 270
Polygon -16777216 true false 105 165 105 285 120 270 180 270 195 285 195 165 180 150 120 150
Rectangle -7500403 true true 195 165 300 285
Rectangle -7500403 true true 0 165 105 285
Line -6459832 false 180 150 180 270
Line -6459832 false 120 150 120 270
Polygon -16777216 true false 22 90 35 109 112 95 97 75
Polygon -14835848 true false 35 110 41 133 115 118 110 95
Polygon -16777216 true false 40 134 116 119 130 135 50 150
Polygon -16777216 true false 48 150 48 161 127 147 127 137
Line -6459832 false 47 151 127 136
Line -16777216 false 92 99 97 119
Line -16777216 false 36 119 94 107
Line -16777216 false 37 112 60 107
Line -16777216 false 40 115 55 112
Circle -16777216 true false 42 126 4
Polygon -7500403 true true 22 90 22 151 47 160 48 150 41 134 35 109
Polygon -6459832 true false 46 135 103 124 110 136 51 147
Line -16777216 false 50 134 56 148
Line -16777216 false 55 133 60 146
Line -16777216 false 59 132 64 145
Line -16777216 false 64 132 68 144
Line -16777216 false 68 131 73 144
Line -16777216 false 73 130 77 142
Line -16777216 false 77 128 82 142
Line -16777216 false 82 128 87 141
Line -16777216 false 86 126 91 139
Line -16777216 false 100 124 106 136
Line -16777216 false 91 126 96 139
Line -16777216 false 95 124 101 138
Line -16777216 false 48 138 104 127
Line -16777216 false 49 142 110 130
Polygon -16777216 true false 11 137 29 135 37 146 46 155 27 162 19 151
Polygon -14835848 true false 16 139 20 146 31 143 26 137
Polygon -6459832 true false 22 148 33 145 40 151 28 154
Polygon -6459832 true false 78 149 79 151 99 147 99 146
Circle -6459832 true false 68 149 4
Polygon -7500403 true true 12 139 12 149 24 167 42 159 45 154 26 161 19 151
Line -16777216 false 22 150 34 146
Line -16777216 false 25 152 36 149
Line -16777216 false 27 147 34 155
Line -16777216 false 30 146 37 154
Rectangle -16777216 true false 0 165 105 180
Rectangle -16777216 true false 195 165 300 180
Rectangle -13840069 true false 15 285 135 270
Rectangle -16777216 true false 195 270 300 285
Rectangle -16777216 true false 0 270 105 285
Line -6459832 false 195 165 195 285
Line -6459832 false 105 165 105 285
Rectangle -16777216 true false 255 15 270 150
Rectangle -14835848 true false 270 15 300 45
Rectangle -16777216 true false 278 18 291 23
Rectangle -16777216 true false 278 27 291 32
Rectangle -16777216 true false 278 36 291 41
Rectangle -16777216 true false 285 19 291 31
Rectangle -16777216 true false 278 28 284 40

till 3
false
0
Circle -1 true false 152 143 9
Polygon -16777216 true false 0 165
Polygon -6459832 true false 0 165 45 135 255 135 300 165
Line -16777216 false 120 270 120 270
Polygon -16777216 true false 105 165 105 285 120 270 180 270 195 285 195 165 180 150 120 150
Rectangle -7500403 true true 195 165 300 285
Rectangle -7500403 true true 0 165 105 285
Line -6459832 false 180 150 180 270
Line -6459832 false 120 150 120 270
Polygon -16777216 true false 22 90 35 109 112 95 97 75
Polygon -14835848 true false 35 110 41 133 115 118 110 95
Polygon -16777216 true false 40 134 116 119 130 135 50 150
Polygon -16777216 true false 48 150 48 161 127 147 127 137
Line -6459832 false 47 151 127 136
Line -16777216 false 92 99 97 119
Line -16777216 false 36 119 94 107
Line -16777216 false 37 112 60 107
Line -16777216 false 40 115 55 112
Circle -16777216 true false 42 126 4
Polygon -7500403 true true 22 90 22 151 47 160 48 150 41 134 35 109
Polygon -6459832 true false 46 135 103 124 110 136 51 147
Line -16777216 false 50 134 56 148
Line -16777216 false 55 133 60 146
Line -16777216 false 59 132 64 145
Line -16777216 false 64 132 68 144
Line -16777216 false 68 131 73 144
Line -16777216 false 73 130 77 142
Line -16777216 false 77 128 82 142
Line -16777216 false 82 128 87 141
Line -16777216 false 86 126 91 139
Line -16777216 false 100 124 106 136
Line -16777216 false 91 126 96 139
Line -16777216 false 95 124 101 138
Line -16777216 false 48 138 104 127
Line -16777216 false 49 142 110 130
Polygon -16777216 true false 11 137 29 135 37 146 46 155 27 162 19 151
Polygon -14835848 true false 16 139 20 146 31 143 26 137
Polygon -6459832 true false 22 148 33 145 40 151 28 154
Polygon -6459832 true false 78 149 79 151 99 147 99 146
Circle -6459832 true false 68 149 4
Polygon -7500403 true true 12 139 12 149 24 167 42 159 45 154 26 161 19 151
Line -16777216 false 22 150 34 146
Line -16777216 false 25 152 36 149
Line -16777216 false 27 147 34 155
Line -16777216 false 30 146 37 154
Rectangle -16777216 true false 0 165 105 180
Rectangle -16777216 true false 195 165 300 180
Rectangle -13840069 true false 15 285 135 270
Rectangle -16777216 true false 195 270 300 285
Rectangle -16777216 true false 0 270 105 285
Line -6459832 false 195 165 195 285
Line -6459832 false 105 165 105 285
Rectangle -16777216 true false 255 15 270 150
Rectangle -14835848 true false 270 15 300 45
Rectangle -16777216 true false 278 18 291 23
Rectangle -16777216 true false 278 27 291 32
Rectangle -16777216 true false 278 36 291 41
Rectangle -16777216 true false 285 19 291 31
Rectangle -16777216 true false 285 28 291 40

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

veggie fridge
false
13
Polygon -16777216 true false 4 18 47 3 46 208 3 226
Rectangle -16777216 true false 47 46 54 210
Polygon -16777216 true false 298 269 249 285 249 300 299 283 294 270
Polygon -14835848 true false 255 195 300 165 45 90 0 120
Polygon -16777216 true false 295 185 251 199 251 204 295 190 295 186 295 186
Polygon -14835848 true false 255 240 300 210 45 135 0 165
Polygon -14835848 true false 255 285 300 255 45 180 0 210
Polygon -16777216 true false 290 272 246 286 246 291 290 277 290 273 290 273
Polygon -16777216 true false 295 231 251 245 251 250 295 236 295 232 295 232
Rectangle -16777216 true false 0 30 9 225
Polygon -14835848 true false 252 151 297 121 42 46 -3 76
Polygon -16777216 true false 294 139 250 153 250 158 294 144 294 140 294 140
Line -16777216 false 45 45 300 120
Polygon -16777216 true false 2 17 5 50 260 125 261 93
Polygon -16777216 true false 2 78 0 74 252 148 254 152
Polygon -16777216 true false 0 210 0 225 255 300 255 285
Polygon -16777216 true false 2 123 0 119 252 193 254 197
Polygon -16777216 true false 2 168 0 164 252 238 254 242
Polygon -16777216 true false 2 213 0 209 252 283 254 287
Rectangle -16777216 true false 255 150 255 300
Rectangle -16777216 true false 251 90 258 284
Polygon -16777216 true false 2 33 0 29 252 103 254 107
Polygon -16777216 true false 296 77 252 91 252 96 296 82 296 78 296 78
Polygon -16777216 true false 256 91 299 76 298 281 255 299
Polygon -7500403 true false 1 16 46 2 299 75 251 90
Line -6459832 false 252 88 252 297
Polygon -10899396 true false 30 179 15 173 20 181 15 182 23 188 12 188 23 192 12 198 30 203 33 210 35 200 43 211 44 199 59 198 47 191 54 185 41 185 40 179 36 186
Polygon -2064490 true true 30 179 15 173 20 181 15 182 23 188 12 188 23 192 12 198 30 203 33 210 35 200 43 211 44 199 59 198 47 191 54 185 41 185 40 179 36 186
Polygon -2064490 true true 58 186 43 180 48 188 43 189 51 195 40 195 51 199 40 205 58 210 61 217 63 207 71 218 72 206 87 205 75 198 82 192 69 192 68 186 64 193
Polygon -10899396 true false 40 188 25 182 30 190 25 191 33 197 22 197 33 201 22 207 40 212 43 219 45 209 53 220 54 208 69 207 57 200 64 194 51 194 50 188 46 195
Circle -13840069 true false 19 133 28
Circle -13840069 true false 19 133 28
Circle -5825686 true false 113 210 28
Circle -5825686 true false 82 200 28
Circle -13840069 true false 84 154 28
Circle -13840069 true false 51 144 28
Polygon -7500403 true false 24 108 34 111 48 115 56 118 77 107 47 97
Circle -1 true false 56 103 11
Polygon -6459832 true false 56 102 60 108 69 108 73 105 72 102 65 99 60 100
Circle -1 true false 41 101 11
Polygon -6459832 true false 40 97 44 103 53 103 57 100 56 97 49 94 44 95
Polygon -6459832 true false 44 113 44 108 47 107 56 108 58 113 58 118
Polygon -6459832 true false 28 109 28 104 31 103 40 104 42 109 42 114
Circle -1 true false 31 108 6
Circle -1 true false 46 112 6
Polygon -16777216 true false 25 109 28 118 53 125 75 114 76 108 52 117
Polygon -7500403 true false 68 122 78 125 92 129 100 132 121 121 91 111
Circle -1 true false 87 112 11
Circle -1 true false 101 116 11
Polygon -6459832 true false 85 110 89 116 98 116 102 113 101 110 94 107 89 108
Polygon -6459832 true false 101 116 105 122 114 122 118 119 117 116 110 113 105 114
Polygon -6459832 true false 75 124 75 119 78 118 87 119 89 124 89 129
Polygon -6459832 true false 89 127 89 122 92 121 101 122 103 127 103 132
Circle -1 true false 78 122 6
Circle -1 true false 92 126 6
Polygon -16777216 true false 69 123 72 132 97 139 119 128 120 122 96 131
Polygon -1 false false 25 159 18 151 19 141 27 132 30 133 27 142 32 151 43 157 38 160
Polygon -1 false false 89 182 82 174 83 164 91 155 94 156 91 165 96 174 107 180 102 183
Polygon -1 false false 57 170 50 162 51 152 59 143 62 144 59 153 64 162 75 168 70 171
Polygon -13345367 false false 88 226 81 218 82 208 90 199 93 200 90 209 95 218 106 224 101 227
Polygon -13345367 false false 119 236 112 228 113 218 121 209 124 210 121 219 126 228 137 234 132 237
Polygon -1 false false 36 134 46 139 47 151 44 157 35 153 40 147 40 140
Polygon -13345367 false false 130 210 140 215 141 227 138 233 129 229 134 223 134 216
Polygon -13345367 false false 98 200 108 205 109 217 106 223 97 219 102 213 102 206
Polygon -1 false false 100 155 110 160 111 172 108 178 99 174 104 168 104 161
Polygon -1 false false 68 145 78 150 79 162 76 168 67 164 72 158 72 151
Polygon -13840069 true false 203 244 206 246 203 253 210 253 210 256 208 258 203 256 200 259 193 258 197 253 193 251 190 251 190 250 187 244 189 241 193 247 194 239 196 231 197 237 198 248
Polygon -1 true false 235 243 231 244 228 251 230 256 227 261 231 263 235 257 243 255 245 247 239 242 233 244 233 244
Polygon -1 true false 217 238 213 239 210 246 212 251 209 256 213 258 217 252 225 250 227 242 221 237 215 239 215 239
Polygon -1 true false 199 231 195 232 192 239 194 244 191 249 195 251 199 245 207 243 209 235 203 230 197 232 197 232
Polygon -1 true false 185 225 181 226 178 233 180 238 177 243 181 245 185 239 193 237 195 229 189 224 183 226 183 226
Polygon -13840069 true false 228 258 231 260 228 267 235 267 235 270 233 272 228 270 225 273 218 272 222 267 218 265 215 265 215 264 212 258 214 255 218 261 219 253 221 245 222 251 223 262
Polygon -13840069 true false 211 254 214 256 211 263 218 263 218 266 216 268 211 266 208 269 201 268 205 263 201 261 198 261 198 260 195 254 197 251 201 257 202 249 204 241 205 247 206 258
Polygon -13840069 true false 192 247 195 249 192 256 199 256 199 259 197 261 192 259 189 262 182 261 186 256 182 254 179 254 179 253 176 247 178 244 182 250 183 242 185 234 186 240 187 251
Polygon -1 true false 227 234 223 235 220 242 222 247 219 252 223 254 227 248 235 246 237 238 231 233 225 235 225 235
Polygon -13840069 true false 223 247 226 249 223 256 230 256 230 259 228 261 223 259 220 262 213 261 217 256 213 254 210 254 210 253 207 247 209 244 213 250 214 242 216 234 217 240 218 251
Polygon -1 true false 209 232 205 233 202 240 204 245 201 250 205 252 209 246 217 244 219 236 213 231 207 233 207 233
Circle -5825686 true false 143 219 28
Polygon -13345367 false false 148 246 141 238 142 228 150 219 153 220 150 229 155 238 166 244 161 247
Polygon -13345367 false false 159 219 169 224 170 236 167 242 158 238 163 232 163 225
Polygon -13840069 true false 180 241 183 243 180 250 187 250 187 253 185 255 180 253 177 256 170 255 174 250 170 248 167 248 167 247 164 241 166 238 170 244 171 236 173 228 174 234 175 245
Polygon -7500403 true false 22 71 32 74 46 78 54 81 71 71 43 62
Polygon -1 true false 42 69 36 69 29 62 29 65 36 71 41 71 31 71 25 64 24 67 32 74 42 71 38 65 39 63 48 72 46 65 48 65 50 75 46 77 43 71
Polygon -6459832 true false 21 69 21 65 24 64 29 66 26 69
Polygon -6459832 true false 21 69 21 65 24 64 29 66 26 69
Polygon -6459832 true false 45 67 45 63 48 62 53 64 50 67
Polygon -6459832 true false 35 66 35 62 38 61 43 63 40 66
Polygon -6459832 true false 27 64 27 60 30 59 35 61 32 64
Polygon -1 true false 54 75 48 75 41 68 41 71 48 77 53 77 43 77 37 70 36 73 44 80 54 77 50 71 51 69 59 76 58 71 60 71 55 77 54 77 55 77
Polygon -6459832 true false 49 73 49 69 52 68 57 70 54 73
Polygon -6459832 true false 40 73 40 69 43 68 48 70 45 73
Polygon -6459832 true false 33 75 33 71 36 70 41 72 38 75
Polygon -16777216 true false 19 70 22 79 47 86 69 75 70 69 46 78
Polygon -7500403 true false 62 81 72 84 86 88 94 91 111 81 83 72
Polygon -1 true false 86 81 80 81 73 74 73 77 80 83 85 83 75 83 69 76 68 79 76 86 86 83 82 77 83 75 92 84 90 77 92 77 94 87 90 89 87 83
Polygon -1 true false 98 84 92 84 85 77 85 80 92 86 97 86 87 86 81 79 80 82 88 89 98 86 94 80 95 78 103 85 102 80 104 80 99 86 98 86 99 86
Polygon -6459832 true false 56 73 56 69 59 68 64 70 61 73
Polygon -6459832 true false 88 86 88 82 91 81 96 83 93 86
Polygon -6459832 true false 96 85 96 81 99 80 104 82 101 85
Polygon -6459832 true false 88 81 88 77 91 76 96 78 93 81
Polygon -6459832 true false 79 84 79 80 82 79 87 81 84 84
Polygon -6459832 true false 78 78 78 74 81 73 86 75 83 78
Polygon -6459832 true false 70 76 70 72 73 71 78 73 75 76
Polygon -6459832 true false 64 79 64 75 67 74 72 76 69 79
Polygon -16777216 true false 60 81 63 90 88 97 110 86 111 80 87 89
Polygon -1 false false 105 93 107 100 119 105 125 97 121 104 141 92 140 89 122 84 107 93 126 99 137 91 122 86
Polygon -13840069 false false 124 93 118 90 116 95 123 94 121 100 114 100 108 93 108 98 115 93 126 88 132 93 125 93 127 99 118 91 112 94 116 101
Polygon -1 false false 212 126 214 133 226 138 232 130 228 137 248 125 247 122 229 117 214 126 233 132 244 124 229 119
Polygon -1 false false 186 119 188 126 200 131 206 123 202 130 222 118 221 115 203 110 188 119 207 125 218 117 203 112
Polygon -1 false false 159 110 161 117 173 122 179 114 175 121 195 109 194 106 176 101 161 110 180 116 191 108 176 103
Polygon -1 false false 133 102 135 109 147 114 153 106 149 113 169 101 168 98 150 93 135 102 154 108 165 100 150 95
Polygon -13840069 false false 232 125 226 122 224 127 231 126 229 132 222 132 216 125 216 130 223 125 234 120 240 125 233 125 235 131 226 123 220 126 224 133
Polygon -13840069 false false 207 118 201 115 199 120 206 119 204 125 197 125 191 118 191 123 198 118 209 113 215 118 208 118 210 124 201 116 195 119 199 126
Polygon -13840069 false false 179 109 173 106 171 111 178 110 176 116 169 116 163 109 163 114 170 109 181 104 187 109 180 109 182 115 173 107 167 110 171 117
Polygon -13840069 false false 153 101 147 98 145 103 152 102 150 108 143 108 137 101 137 106 144 101 155 96 161 101 154 101 156 107 147 99 141 102 145 109
Polygon -2064490 true true 127 171 180 187 186 185 189 183 184 178 134 164 126 165 124 167
Polygon -2064490 true true 115 194 168 210 175 209 176 206 172 201 122 187 115 186 111 188
Polygon -2064490 true true 122 182 175 198 182 196 184 192 179 189 129 175 120 175 119 178
Polygon -1 true false 123 195 127 189 134 191 130 198
Polygon -1 true false 134 172 138 166 145 168 141 175
Polygon -1 true false 126 182 130 176 137 178 133 185
Polygon -2064490 true true 192 199 188 198 184 196 188 193 186 189 187 187 187 186 190 184 193 184 194 185 198 185 200 184 203 181 207 181 209 185 209 187 213 188 217 189 220 190 221 193 220 198 220 201 220 206 217 207 212 207 210 206 208 202
Polygon -13840069 true false 197 208 204 211 205 203 211 200 216 200 214 197 205 199 209 192 206 189 202 200 202 192 198 192 200 202 193 190 191 193 201 205
Polygon -2064490 true true 219 209 215 208 211 206 215 203 213 199 214 197 214 196 217 194 220 194 221 195 225 195 227 194 230 191 234 191 236 195 236 197 240 198 244 199 247 200 248 203 247 208 247 211 247 216 244 217 239 217 237 216 235 212
Polygon -13840069 true false 224 217 231 220 232 212 238 209 243 209 241 206 232 208 236 201 233 198 229 209 229 201 225 201 227 211 220 199 218 202 228 214
Polygon -2064490 true true 200 215 196 214 192 212 196 209 194 205 195 203 195 202 198 200 201 200 202 201 206 201 208 200 211 197 215 197 217 201 217 203 221 204 225 205 228 206 229 209 228 214 228 217 228 222 225 223 220 223 218 222 216 218
Polygon -13840069 true false 205 223 212 226 213 218 219 215 224 215 222 212 213 214 217 207 214 204 210 215 210 207 206 207 208 217 201 205 199 208 209 220
Circle -2674135 true false 119 134 7
Circle -2674135 true false 127 137 7
Circle -2674135 true false 135 134 7
Circle -2674135 true false 133 126 7
Circle -2674135 true false 125 128 7
Circle -2674135 true false 141 128 7
Circle -2674135 true false 147 142 7
Circle -2674135 true false 154 144 7
Circle -2674135 true false 161 141 7
Circle -2674135 true false 169 137 7
Circle -2674135 true false 163 134 7
Circle -2674135 true false 155 136 7
Polygon -10899396 false false 123 136 129 132 129 141 134 129 136 136 141 133
Polygon -10899396 false false 151 143 157 139 157 148 162 136 164 143 169 140
Polygon -1 false false 144 141 146 148 158 153 164 145 160 152 180 140 179 137 161 132 146 141 165 147 176 139 161 134
Polygon -1 false false 116 133 118 140 130 145 136 137 132 144 152 132 151 129 133 124 118 133 137 139 148 131 133 126
Polygon -1 false false 179 148 187 147 208 151 212 159 207 174 204 172 203 170 186 164
Polygon -1 false false 216 158 224 160 235 164 242 164 242 166 246 170 241 183 218 176 216 162
Polygon -1 false false 214 158 222 157 243 161 247 169 242 184 239 182 238 180 221 174
Polygon -1 false false 203 144 211 146 222 150 229 150 229 152 233 156 228 169 205 162 203 148
Polygon -1 false false 179 148 187 150 198 154 205 154 205 156 209 160 204 173 181 166 179 152
Polygon -1 false false 204 145 212 144 233 148 237 156 232 171 229 169 228 167 211 161
Line -2064490 true 186 150 184 164
Line -2064490 true 191 150 188 165
Line -2064490 true 198 153 192 168
Line -2064490 true 203 154 197 165
Line -2064490 true 207 157 203 168
Line -2064490 true 211 144 210 159
Line -2064490 true 218 147 214 160
Line -2064490 true 223 152 217 162
Line -2064490 true 230 151 223 161
Line -2064490 true 233 153 227 167
Line -2064490 true 206 149 208 161
Line -2064490 true 219 161 223 173
Line -2064490 true 224 163 226 177
Line -2064490 true 231 163 227 177
Line -2064490 true 239 163 233 178
Line -2064490 true 242 167 238 182
Line -13840069 false 183 151 183 156
Line -13840069 false 192 153 192 167
Line -13840069 false 202 154 199 170
Line -13840069 false 210 159 206 170
Line -13840069 false 207 148 210 161
Line -13840069 false 214 149 214 161
Line -13840069 false 223 150 220 164
Line -13840069 false 233 153 227 160
Line -13840069 false 221 163 222 172
Line -13840069 false 234 162 230 175
Line -13840069 false 239 164 238 178
Line -1 false 41 96 23 155
Line -1 false 63 66 22 190
Line -1 false 50 126 37 162
Circle -1 false false 62 161 11
Line -1 false 110 123 92 182
Line -1 false 132 106 91 230
Line -1 false 132 140 119 176
Circle -1 false false 150 187 11
Line -1 false 218 118 177 242
Line -1 false 195 147 177 206
Line -1 false 204 183 191 219
Circle -1 false false 234 211 11
Polygon -1 false false 6 51 5 208 77 229 81 72
Polygon -1 false false 86 75 83 231 163 257 165 98
Polygon -1 false false 171 100 168 256 248 282 250 123

veggie island
false
0
Polygon -6459832 true false -1 301 -1 256 59 181 239 181 299 256 299 301
Line -16777216 false 0 255 300 255
Line -16777216 false 60 180 0 255
Line -16777216 false 0 255 0 300
Line -16777216 false 0 300 300 300
Line -16777216 false 300 300 300 255
Line -16777216 false 300 255 240 180
Line -16777216 false 60 180 240 180
Polygon -6459832 true false 60 240 60 195 75 165 225 165 240 195 240 240
Line -16777216 false 60 195 75 165
Polygon -16777216 true false 239 179 225 165 232 181
Polygon -16777216 true false 61 179 75 165 68 181
Rectangle -16777216 false false 60 194 241 225
Line -16777216 false 225 165 240 195
Rectangle -6459832 true false 105 105 195 105
Rectangle -6459832 true false 105 150 195 180
Rectangle -16777216 false false 105 150 195 180
Polygon -6459832 true false 105 150 120 135 180 135 195 150
Polygon -16777216 false false 120 135 105 150 195 150 180 135
Polygon -16777216 true false 182 194 207 255 182 225
Rectangle -1 true false 6 261 30 273
Rectangle -1 true false 97 261 121 273
Rectangle -1 true false 214 261 238 273
Rectangle -1 true false 64 198 80 206
Rectangle -1 true false 118 198 134 206
Rectangle -1 true false 191 198 207 206
Rectangle -1 true false 113 154 129 162
Rectangle -1 true false 105 90 195 120
Rectangle -16777216 false false 105 90 195 120
Rectangle -16777216 true false 144 120 158 144
Circle -16777216 true false 8 263 8
Circle -16777216 true false 98 262 8
Circle -16777216 true false 217 262 8
Circle -16777216 true false 192 198 6
Circle -16777216 true false 118 199 6
Circle -16777216 true false 66 199 6
Circle -16777216 true false 115 155 6
Rectangle -16777216 true false 0 285 300 300
Circle -5825686 true false 199 234 18
Polygon -5825686 true false 205 235 208 230 210 234
Polygon -955883 true false 159 214 155 215 162 243 165 245 163 215
Polygon -955883 true false 175 228 182 228 180 247 178 252 176 248
Polygon -955883 true false 181 98 185 100 180 116 177 117
Polygon -955883 true false 136 223 141 226 140 230 128 248 125 248
Polygon -955883 true false 119 218 126 218 124 237 122 242 120 238
Polygon -955883 true false 184 99 187 98 193 109 192 113 189 110
Polygon -955883 true false 124 205 120 206 127 234 130 236 128 206
Polygon -955883 true false 118 212 124 213 116 243 113 244
Polygon -13840069 true false 238 109
Polygon -955883 true false 161 214 157 215 168 242 172 245 165 215
Polygon -2064490 true false 52 191 52 178 55 170 63 167 59 163 69 154 80 155 76 161 76 165 63 190 55 195
Circle -6459832 true false 59 167 10
Circle -6459832 true false 52 175 10
Circle -6459832 true false 55 180 10
Polygon -1 true false 38 208 38 195 41 187 49 184 45 180 55 171 66 172 67 180 62 191 49 207 41 212
Circle -6459832 true false 51 180 10
Circle -6459832 true false 40 188 10
Circle -6459832 true false 48 192 10
Circle -6459832 true false 40 200 10
Polygon -2064490 true false 24 231 24 218 27 210 35 207 31 203 41 194 52 195 48 201 51 206 35 230 27 235
Circle -6459832 true false 37 202 10
Circle -6459832 true false 24 220 10
Circle -6459832 true false 35 216 10
Circle -6459832 true false 26 209 10
Polygon -16777216 true false 60 195 0 255 60 225
Circle -6459832 true false 108 106 10
Circle -5825686 true false 218 235 18
Polygon -5825686 true false 223 236 226 231 228 235
Polygon -955883 true false 171 222 178 226 167 251 164 252
Polygon -955883 true false 178 225 177 224 184 252 187 254 182 225
Circle -2674135 true false 268 220 11
Circle -2674135 true false 268 220 11
Circle -2674135 true false 260 216 11
Circle -2674135 true false 251 200 11
Circle -2674135 true false 238 186 11
Circle -2674135 true false 231 176 11
Circle -2674135 true false 238 181 11
Circle -2674135 true false 244 188 11
Circle -2674135 true false 241 198 11
Circle -2674135 true false 258 208 11
Polygon -16777216 true false 240 195 300 255 240 225
Circle -5825686 true false 220 200 18
Circle -5825686 true false 235 203 18
Circle -5825686 true false 248 218 18
Circle -5825686 true false 230 221 18
Circle -5825686 true false 209 217 18
Circle -5825686 true false 189 216 18
Circle -5825686 true false 274 236 18
Circle -5825686 true false 256 236 18
Circle -5825686 true false 237 236 18
Circle -5825686 true false 184 201 18
Circle -5825686 true false 202 200 18
Polygon -5825686 true false 136 101 139 96 141 100
Polygon -5825686 true false 241 204 244 199 246 203
Polygon -5825686 true false 226 202 229 197 231 201
Polygon -5825686 true false 207 201 210 196 212 200
Polygon -5825686 true false 188 203 191 198 193 202
Polygon -5825686 true false 214 218 217 213 219 217
Polygon -5825686 true false 234 222 237 217 239 221
Polygon -5825686 true false 253 219 256 214 258 218
Polygon -5825686 true false 280 237 283 232 285 236
Polygon -5825686 true false 262 237 265 232 267 236
Polygon -5825686 true false 242 237 245 232 247 236
Circle -14835848 true false 194 151 19
Circle -14835848 true false 212 173 19
Circle -14835848 true false 194 169 19
Circle -14835848 true false 212 158 19
Circle -5825686 true false 213 183 18
Circle -5825686 true false 192 185 18
Circle -14835848 true false 117 94 19
Circle -6459832 true false 112 105 10
Polygon -5825686 true false 196 187 199 182 201 186
Polygon -5825686 true false 218 184 221 179 223 183
Circle -1184463 true false 222 177 4
Circle -1184463 true false 221 161 4
Circle -1184463 true false 203 156 4
Circle -1184463 true false 125 97 4
Circle -1184463 true false 203 174 4
Circle -14835848 true false 174 172 19
Circle -14835848 true false 160 159 19
Circle -14835848 true false 175 153 19
Circle -14835848 true false 153 174 19
Circle -1184463 true false 159 182 4
Circle -1184463 true false 178 175 4
Circle -1184463 true false 164 165 4
Circle -1184463 true false 185 161 4
Polygon -13840069 true false 138 230 143 212 142 206 135 205 133 209 133 202 128 207 131 200 127 199 137 193 142 197 148 208 149 200 154 191 163 191 168 198 164 198 164 203 160 202 158 205 156 202 152 204 151 210 146 221
Polygon -955883 true false 134 228 141 228 139 247 137 252 135 248
Polygon -955883 true false 141 222 137 223 144 251 147 253 145 223
Polygon -13840069 true false 154 227 159 204 155 195 163 181 173 189 172 197 167 195 167 204 164 203 165 207 165 207 160 211 175 201 186 206 185 213 178 210 178 216 173 212 172 216 165 214 160 218
Polygon -955883 true false 157 213 163 214 155 244 152 245
Polygon -955883 true false 156 215 161 218 160 222 148 240 145 240
Polygon -13840069 true false 173 235 178 212 174 203 182 189 192 197 191 205 186 203 186 212 183 211 184 215 184 215 179 219 194 209 205 214 204 221 197 218 197 224 192 220 191 224 184 222 179 226
Polygon -955883 true false 174 221 180 222 172 252 169 253
Circle -5825686 true false 131 100 18
Circle -2674135 true false 117 106 11
Polygon -10899396 true false 97 165 97 150 100 145 106 143 110 148 107 149 104 149 104 156 104 160 103 164
Polygon -10899396 true false 96 166 96 151 93 146 87 144 83 149 86 150 89 150 89 157 89 161 90 165
Polygon -1184463 true false 91 164 92 141 96 134 99 133 102 141 102 163 97 169
Polygon -10899396 true false 86 157 91 150 95 150 95 169 91 164 91 157
Polygon -10899396 true false 157 116 157 101 160 96 166 94 170 99 167 100 164 100 164 107 164 111 163 115
Polygon -10899396 true false 81 167 81 152 84 147 90 145 94 150 91 151 88 151 88 158 88 162 87 166
Polygon -10899396 true false 79 166 79 151 76 146 70 144 66 149 69 150 72 150 72 157 72 161 73 165
Polygon -1184463 true false 75 165 76 142 80 135 83 134 86 142 86 164 81 170
Polygon -10899396 true false 72 159 77 152 81 152 81 171 77 166 77 159
Polygon -10899396 true false 72 182 72 167 69 162 63 160 59 165 62 166 65 166 65 173 65 177 66 181
Polygon -1184463 true false 67 181 68 158 72 151 75 150 78 158 78 180 73 186
Polygon -10899396 true false 74 184 74 169 77 164 83 162 87 167 84 168 81 168 81 175 81 179 80 183
Polygon -10899396 true false 62 173 67 166 71 166 71 185 67 180 67 173
Polygon -10899396 true false 93 184 93 169 96 164 102 162 106 167 103 168 100 168 100 175 100 179 99 183
Polygon -1184463 true false 84 183 85 160 89 153 92 152 95 160 95 182 90 188
Polygon -10899396 true false 91 187 91 172 88 167 82 165 78 170 81 171 84 171 84 178 84 182 85 186
Polygon -1184463 true false 105 185 106 162 110 155 113 154 116 162 116 184 111 190
Polygon -10899396 true false 112 186 112 171 115 166 121 164 125 169 122 170 119 170 119 177 119 181 118 185
Polygon -10899396 true false 100 177 105 170 109 170 109 189 105 184 105 177
Polygon -1184463 true false 123 186 124 163 128 156 131 155 134 163 134 185 129 191
Polygon -10899396 true false 129 190 129 175 132 170 138 168 142 173 139 174 136 174 136 181 136 185 135 189
Polygon -10899396 true false 128 190 128 175 125 170 119 168 115 173 118 174 121 174 121 181 121 185 122 189
Polygon -1184463 true false 141 186 142 163 146 156 149 155 152 163 152 185 147 191
Polygon -10899396 true false 148 186 148 171 151 166 157 164 161 169 158 170 155 170 155 177 155 181 154 185
Polygon -10899396 true false 136 180 141 173 145 173 145 192 141 187 141 180
Polygon -13840069 true false 120 215 125 197 124 191 117 190 115 194 115 187 110 192 113 185 109 184 119 178 124 182 130 193 131 185 136 176 145 176 150 183 146 183 146 188 142 187 140 190 138 187 134 189 133 195 128 206
Polygon -955883 true false 119 206 124 209 123 213 111 231 108 231
Polygon -1184463 true false 150 113 150 99 152 92 158 93 159 99 161 112 156 118
Polygon -10899396 true false 146 107 151 100 155 100 155 119 151 114 151 107
Polygon -7500403 true true 113 146 110 143 110 136 113 133 115 131 115 126 116 122 120 121 125 122 126 125 126 130 126 134 129 135 129 139 129 144 123 146 121 148
Polygon -7500403 true true 113 146 110 143 110 136 113 133 115 131 115 126 116 122 120 121 125 122 126 125 126 130 126 134 129 135 129 139 129 144 123 146 121 148
Polygon -7500403 true true 164 147 161 144 161 137 164 134 166 132 166 127 167 123 171 122 176 123 177 126 177 131 177 135 180 136 180 140 180 145 174 147 172 149
Polygon -7500403 true true 136 147 133 144 133 137 136 134 138 132 138 127 139 123 143 122 148 123 149 126 149 131 149 135 152 136 152 140 152 145 146 147 144 149
Polygon -955883 true false 181 101 186 96 186 102 188 117 185 117
Polygon -13840069 true false 181 100 179 92 174 91 186 92 186 100
Polygon -2674135 true false 21 236 17 232 15 235 15 247 19 252 23 250 27 253 31 250 33 239 31 234 28 234 25 236 25 232
Polygon -14835848 true false 101 181 103 178 103 173 107 173 106 177 109 181
Polygon -14835848 true false 60 239 56 235 54 238 54 250 58 255 62 253 66 256 70 253 72 242 70 237 67 237 64 239 64 235
Polygon -1184463 true false 40 238 36 234 34 237 34 249 38 254 42 252 46 255 50 252 52 241 50 236 47 236 44 238 44 234
Polygon -2674135 true false 79 239 75 235 73 238 73 250 77 255 81 253 85 256 89 253 91 242 89 237 86 237 83 239 83 235
Polygon -14835848 true false 34 217 30 213 28 216 28 228 32 233 36 231 40 234 44 231 46 220 44 215 41 215 38 217 38 213
Polygon -2674135 true false 55 221 51 217 49 220 49 232 53 237 57 235 61 238 65 235 67 224 65 219 62 219 59 221 59 217
Polygon -1184463 true false 76 220 72 216 70 219 70 231 74 236 78 234 82 237 86 234 88 223 86 218 83 218 80 220 80 216
Polygon -14835848 true false 95 221 91 217 89 220 89 232 93 237 97 235 101 238 105 235 107 224 105 219 102 219 99 221 99 217
Polygon -1184463 true false 51 197 47 193 45 196 45 208 49 213 53 211 57 214 61 211 63 200 61 195 58 195 55 197 55 193
Polygon -14835848 true false 70 201 66 197 64 200 64 212 68 217 72 215 76 218 80 215 82 204 80 199 77 199 74 201 74 197
Polygon -2674135 true false 91 201 87 197 85 200 85 212 89 217 93 215 97 218 101 215 103 204 101 199 98 199 95 201 95 197
Polygon -2674135 true false 67 181 63 177 61 180 61 192 65 197 69 195 73 198 77 195 79 184 77 179 74 179 71 181 71 177
Polygon -1184463 true false 85 182 81 178 79 181 79 193 83 198 87 196 91 199 95 196 97 185 95 180 92 180 89 182 89 178
Polygon -14835848 true false 103 180 99 176 97 179 97 191 101 196 105 194 109 197 113 194 115 183 113 178 110 178 107 180 107 176
Polygon -16777216 true false 112 194 90 255 111 226
Polygon -14835848 true false 83 182 85 179 85 174 89 174 88 178 91 182
Polygon -14835848 true false 68 183 70 180 70 175 74 175 73 179 76 183
Polygon -14835848 true false 89 200 91 197 91 192 95 192 94 196 97 200
Polygon -14835848 true false 68 201 70 198 70 193 74 193 73 197 76 201
Polygon -14835848 true false 50 198 52 195 52 190 56 190 55 194 58 198
Polygon -14835848 true false 33 218 35 215 35 210 39 210 38 214 41 218
Polygon -14835848 true false 53 222 55 219 55 214 59 214 58 218 61 222
Polygon -14835848 true false 76 222 78 219 78 214 82 214 81 218 84 222
Polygon -14835848 true false 94 221 96 218 96 213 100 213 99 217 102 221
Polygon -14835848 true false 76 239 78 236 78 231 82 231 81 235 84 239
Polygon -14835848 true false 59 239 61 236 61 231 65 231 64 235 67 239
Polygon -14835848 true false 37 239 39 236 39 231 43 231 42 235 45 239
Polygon -14835848 true false 20 236 22 233 22 228 26 228 25 232 28 236
Polygon -2674135 true false 167 104 163 100 161 103 161 115 165 120 169 118 173 121 177 118 179 107 177 102 174 102 171 104 171 100
Polygon -14835848 true false 167 103 169 100 169 95 173 95 172 99 175 103

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wine fridge
false
4
Polygon -16777216 true false 4 18 47 3 46 208 3 226
Rectangle -16777216 true false 47 46 54 210
Polygon -16777216 true false 298 269 249 285 249 300 299 283 294 270
Polygon -6459832 true false 255 285 300 255 45 180 0 210
Polygon -16777216 true false 290 272 246 286 246 291 290 277 290 273 290 273
Rectangle -16777216 true false 0 30 9 225
Line -16777216 false 45 45 300 120
Polygon -16777216 true false 0 210 0 225 255 300 255 285
Polygon -16777216 true false 2 213 0 209 252 283 254 287
Rectangle -16777216 true false 255 150 255 300
Polygon -16777216 true false 296 77 252 91 252 96 296 82 296 78 296 78
Polygon -7500403 true false 1 16 46 2 299 75 251 90
Polygon -14835848 true false 26 172 26 181 20 187 21 203 28 206 35 204 35 186 30 181 31 172
Polygon -14835848 true false 73 174 73 183 67 189 68 205 75 208 82 206 82 188 77 183 78 174
Polygon -14835848 true false 57 182 57 191 51 197 52 213 59 216 66 214 66 196 61 191 62 182
Polygon -14835848 true false 43 163 43 172 37 178 38 194 45 197 52 195 52 177 47 172 48 163
Polygon -14835848 true false 57 182 57 191 51 197 52 213 59 216 66 214 66 196 61 191 62 182
Polygon -14835848 true false 57 182 57 191 51 197 52 213 59 216 66 214 66 196 61 191 62 182
Polygon -14835848 true false 137 198 137 207 131 213 132 229 139 232 146 230 146 212 141 207 142 198
Polygon -14835848 true false 120 203 120 212 114 218 115 234 122 237 129 235 129 217 124 212 125 203
Polygon -14835848 true false 103 186 103 195 97 201 98 217 105 220 112 218 112 200 107 195 108 186
Polygon -14835848 true false 86 194 86 203 80 209 81 225 88 228 95 226 95 208 90 203 91 194
Circle -16777216 true false 22 188 12
Circle -16777216 true false 69 190 12
Circle -16777216 true false 52 198 12
Circle -16777216 true false 40 179 12
Circle -1 true false 134 213 12
Circle -1 true false 116 218 12
Circle -1 true false 81 208 12
Circle -1 true false 98 202 12
Polygon -1184463 true true 186 225 186 234 180 240 181 256 188 259 195 257 195 239 190 234 191 225
Polygon -1184463 true true 170 210 170 219 164 225 165 241 172 244 179 242 179 224 174 219 175 210
Polygon -1184463 true true 152 213 152 222 146 228 147 244 154 247 161 245 161 227 156 222 157 213
Polygon -1184463 true true 236 232 236 241 230 247 231 263 238 266 245 264 245 246 240 241 241 232
Polygon -1184463 true true 218 234 218 243 212 249 213 265 220 268 227 266 227 248 222 243 223 234
Polygon -1184463 true true 202 218 202 227 196 233 197 249 204 252 211 250 211 232 206 227 207 218
Circle -1 true false 182 242 12
Circle -1 true false 231 247 12
Circle -1 true false 214 250 12
Circle -1 true false 197 233 12
Circle -11221820 true false 147 227 12
Circle -11221820 true false 165 224 12
Polygon -6459832 true false 254 240 299 210 44 135 -1 165
Polygon -14835848 true false 120 162 120 171 114 177 115 193 122 196 129 194 129 176 124 171 125 162
Polygon -14835848 true false 103 147 103 156 97 162 98 178 105 181 112 179 112 161 107 156 108 147
Polygon -14835848 true false 87 152 87 161 81 167 82 183 89 186 96 184 96 166 91 161 92 152
Polygon -14835848 true false 63 145 63 154 57 160 58 176 65 179 72 177 72 159 67 154 68 145
Polygon -14835848 true false 48 130 48 139 42 145 43 161 50 164 57 162 57 144 52 139 53 130
Polygon -14835848 true false 30 135 30 144 24 150 25 166 32 169 39 167 39 149 34 144 35 135
Polygon -1184463 true true 181 179 181 188 175 194 176 210 183 213 190 211 190 193 185 188 186 179
Polygon -1184463 true true 164 166 164 175 158 181 159 197 166 200 173 198 173 180 168 175 169 166
Polygon -1184463 true true 147 168 147 177 141 183 142 199 149 202 156 200 156 182 151 177 152 168
Polygon -1184463 true true 238 194 238 203 232 209 233 225 240 228 247 226 247 208 242 203 243 194
Polygon -1184463 true true 221 183 221 192 215 198 216 214 223 217 230 215 230 197 225 192 226 183
Polygon -1184463 true true 205 186 205 195 199 201 200 217 207 220 214 218 214 200 209 195 210 186
Polygon -10899396 true false 144 186 154 187 154 195 144 194
Polygon -10899396 true false 144 186 154 187 154 195 144 194
Polygon -10899396 true false 234 212 244 213 244 221 234 220
Polygon -10899396 true false 218 201 228 202 228 210 218 209
Polygon -10899396 true false 201 204 211 205 211 213 201 212
Polygon -10899396 true false 177 197 187 198 187 206 177 205
Polygon -10899396 true false 160 182 170 183 170 191 160 190
Polygon -1 true false 26 152 36 153 36 161 26 160
Polygon -1 true false 59 163 69 164 69 172 59 171
Polygon -1 true false 45 147 55 148 55 156 45 155
Polygon -2674135 true false 83 170 93 171 93 179 83 178
Polygon -2674135 true false 116 179 126 180 126 188 116 187
Polygon -2674135 true false 100 163 110 164 110 172 100 171
Polygon -6459832 true false 255 195 300 165 45 90 0 120
Polygon -16777216 true false 2 168 0 164 252 238 254 242
Polygon -16777216 true false 2 123 0 119 252 193 254 197
Polygon -14835848 true false 21 87 21 96 15 102 16 118 23 121 30 119 30 101 25 96 26 87
Polygon -14835848 true false 126 113 126 122 120 128 121 144 128 147 135 145 135 127 130 122 131 113
Polygon -14835848 true false 108 114 108 123 102 129 103 145 110 148 117 146 117 128 112 123 113 114
Polygon -14835848 true false 94 95 94 104 88 110 89 126 96 129 103 127 103 109 98 104 99 95
Polygon -14835848 true false 79 104 79 113 73 119 74 135 81 138 88 136 88 118 83 113 84 104
Polygon -14835848 true false 68 81 68 90 62 96 63 112 70 115 77 113 77 95 72 90 73 81
Polygon -14835848 true false 53 95 53 104 47 110 48 126 55 129 62 127 62 109 57 104 58 95
Polygon -14835848 true false 39 80 39 89 33 95 34 111 41 114 48 112 48 94 43 89 44 80
Polygon -1184463 true true 138 119 138 128 132 134 133 150 140 153 147 151 147 133 142 128 143 119
Polygon -1184463 true true 240 144 240 153 234 159 235 175 242 178 249 176 249 158 244 153 245 144
Polygon -1184463 true true 224 145 224 154 218 160 219 176 226 179 233 177 233 159 228 154 229 145
Polygon -1184463 true true 212 128 212 137 206 143 207 159 214 162 221 160 221 142 216 137 217 128
Polygon -1184463 true true 197 138 197 147 191 153 192 169 199 172 206 170 206 152 201 147 202 138
Polygon -1184463 true true 185 123 185 132 179 138 180 154 187 157 194 155 194 137 189 132 190 123
Polygon -1184463 true true 168 132 168 141 162 147 163 163 170 166 177 164 177 146 172 141 173 132
Polygon -1184463 true true 154 114 154 123 148 129 149 145 156 148 163 146 163 128 158 123 159 114
Circle -1 true false 134 135 12
Circle -1 true false 162 148 12
Circle -1 true false 149 130 12
Polygon -1184463 true true 75 121 85 122 85 130 75 129
Polygon -1184463 true true 122 131 132 132 132 140 122 139
Polygon -1184463 true true 104 132 114 133 114 141 104 140
Polygon -1184463 true true 90 112 100 113 100 121 90 120
Circle -16777216 true false 180 139 12
Circle -16777216 true false 180 139 12
Circle -16777216 true false 235 159 12
Circle -16777216 true false 220 160 12
Circle -16777216 true false 208 143 12
Circle -16777216 true false 193 154 12
Circle -5825686 true false 16 102 12
Circle -5825686 true false 63 96 12
Circle -5825686 true false 49 111 12
Circle -5825686 true false 34 95 12
Polygon -6459832 true false 255 150 300 120 45 45 0 75
Polygon -16777216 true false 2 33 0 29 252 103 254 107
Polygon -16777216 true false 2 78 0 74 252 148 254 152
Polygon -14835848 true false 22 43 22 52 16 58 17 74 24 77 31 75 31 57 26 52 27 43
Polygon -14835848 true false 84 61 84 70 78 76 79 92 86 95 93 93 93 75 88 70 89 61
Polygon -14835848 true false 59 56 59 65 53 71 54 87 61 90 68 88 68 70 63 65 64 56
Polygon -14835848 true false 41 49 41 58 35 64 36 80 43 83 50 81 50 63 45 58 46 49
Polygon -14835848 true false 119 74 119 83 113 89 114 105 121 108 128 106 128 88 123 83 124 74
Polygon -14835848 true false 101 66 101 75 95 81 96 97 103 100 110 98 110 80 105 75 106 66
Polygon -1184463 true true 143 80 143 89 137 95 138 111 145 114 152 112 152 94 147 89 148 80
Polygon -1184463 true true 244 109 244 118 238 124 239 140 246 143 253 141 253 123 248 118 249 109
Polygon -1184463 true true 226 105 226 114 220 120 221 136 228 139 235 137 235 119 230 114 231 105
Polygon -1184463 true true 208 98 208 107 202 113 203 129 210 132 217 130 217 112 212 107 213 98
Polygon -1184463 true true 179 90 179 99 173 105 174 121 181 124 188 122 188 104 183 99 184 90
Polygon -1184463 true true 162 84 162 93 156 99 157 115 164 118 171 116 171 98 166 93 167 84
Polygon -16777216 true false 2 17 2 35 260 111 261 93
Polygon -1 true false 204 115 214 116 214 124 204 123
Polygon -1 true false 240 126 250 127 250 135 240 134
Polygon -1 true false 223 123 233 124 233 132 223 131
Circle -1 true false 79 77 12
Circle -1 true false 115 91 12
Circle -1 true false 97 82 12
Polygon -16777216 true false 19 60 29 61 29 69 19 68
Polygon -16777216 true false 55 73 65 74 65 82 55 81
Polygon -16777216 true false 37 67 47 68 47 76 37 75
Polygon -2674135 true false 140 97 150 98 150 106 140 105
Polygon -2674135 true false 175 108 185 109 185 117 175 116
Polygon -2674135 true false 158 102 168 103 168 111 158 110
Polygon -1 false false 5 35 5 208 77 229 81 58
Polygon -1 false false 87 59 83 231 163 257 166 83
Polygon -1 false false 172 84 168 256 248 282 250 109
Rectangle -16777216 true false 251 90 258 284
Line -6459832 false 252 88 252 297
Polygon -16777216 true false 257 91 300 76 299 281 256 299
Line -1 false 41 96 23 155
Line -1 false 63 66 22 190
Line -1 false 50 126 37 162
Circle -1 false false 62 146 11
Line -1 false 125 123 107 182
Line -1 false 147 91 106 215
Line -1 false 132 170 119 206
Circle -1 false false 150 172 11
Line -1 false 210 147 192 206
Line -1 false 233 118 192 242
Line -1 false 219 198 206 234
Circle -1 false false 234 196 11

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="PrevalenceVariation" repetitions="20" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="2"/>
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="InfectStaffVariation" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="VaccineVariation" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="TillServiceVariation" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="SickLeaveVariation" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Step-SizeVariation" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="20"/>
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="PointsVariation" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="USA06" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
      <value value="&quot;prevalence&quot;"/>
      <value value="&quot;till-service-speed&quot;"/>
      <value value="&quot;step-size&quot;"/>
      <value value="&quot;dissipation-rate&quot;"/>
      <value value="&quot;shop-size&quot;"/>
      <value value="&quot;proportion-as&quot;"/>
      <value value="&quot;as-rel-inf&quot;"/>
      <value value="&quot;direct-trans&quot;"/>
      <value value="&quot;v1-efficacy&quot;"/>
      <value value="&quot;v2-efficacy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;low&quot;"/>
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="USA02" repetitions="20" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;step-size&quot;"/>
      <value value="&quot;dissipation-rate&quot;"/>
      <value value="&quot;vax-active?&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;low&quot;"/>
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="USA Crowd" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="crowd-size">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="USA04" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;step-size&quot;"/>
      <value value="&quot;dissipation-rate&quot;"/>
      <value value="&quot;v1-efficacy&quot;"/>
      <value value="&quot;v2-efficacy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;low&quot;"/>
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INT01" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;No Vaccines&quot;"/>
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
      <value value="&quot;Staff Vaccine Mandate&quot;"/>
      <value value="&quot;Full Vaccine Mandate&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INT02" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;No Vaccines&quot;"/>
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
      <value value="&quot;Staff Vaccine Mandate&quot;"/>
      <value value="&quot;Full Vaccine Mandate&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="USA07" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
      <value value="&quot;prevalence&quot;"/>
      <value value="&quot;till-service-speed&quot;"/>
      <value value="&quot;step-size&quot;"/>
      <value value="&quot;dissipation-rate&quot;"/>
      <value value="&quot;shop-size&quot;"/>
      <value value="&quot;proportion-as&quot;"/>
      <value value="&quot;as-rel-inf&quot;"/>
      <value value="&quot;direct-trans&quot;"/>
      <value value="&quot;v1-efficacy&quot;"/>
      <value value="&quot;v2-efficacy&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;low&quot;"/>
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="USA08" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
      <value value="&quot;till-service-speed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;low&quot;"/>
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTVax" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;No Vaccines&quot;"/>
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
      <value value="&quot;Staff Vaccine Mandate&quot;"/>
      <value value="&quot;Full Vaccine Mandate&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTCap" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;50%&quot;"/>
      <value value="&quot;75%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTTest" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;Daily&quot;"/>
      <value value="&quot;Weekly&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="USASS" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;shop-size&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MSA01" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="USASS" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="vax-active?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;shop-size&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTSDist" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTSan" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;Entrance&quot;"/>
      <value value="&quot;Entrance and Tills&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTComb01" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
      <value value="&quot;Staff Vaccine Mandate&quot;"/>
      <value value="&quot;Full Vaccine Mandate&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
      <value value="&quot;50%&quot;"/>
      <value value="&quot;75%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
      <value value="&quot;Daily&quot;"/>
      <value value="&quot;Weekly&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
      <value value="&quot;Entrance&quot;"/>
      <value value="&quot;Entrance and Tills&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTComb02" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
      <value value="&quot;50%&quot;"/>
      <value value="&quot;75%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
      <value value="&quot;Daily&quot;"/>
      <value value="&quot;Weekly&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
      <value value="&quot;Entrance&quot;"/>
      <value value="&quot;Entrance and Tills&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTComb03" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Staff Vaccine Mandate&quot;"/>
      <value value="&quot;Full Vaccine Mandate&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
      <value value="&quot;50%&quot;"/>
      <value value="&quot;75%&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
      <value value="&quot;Daily&quot;"/>
      <value value="&quot;Weekly&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
      <value value="&quot;Entrance&quot;"/>
      <value value="&quot;Entrance and Tills&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTTestPrev" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="2"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
      <value value="&quot;Daily&quot;"/>
      <value value="&quot;Weekly&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTSDistPrev" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="2"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTSDistSS" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ss-distribution">
      <value value="&quot;More Contacts&quot;"/>
      <value value="&quot;Fewer Contacts&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="INTSanSS" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="11749"/>
    <metric>total-shop-infections</metric>
    <metric>formite-infections</metric>
    <metric>shopq-infections</metric>
    <metric>shop-infections</metric>
    <metric>tillq-infections</metric>
    <metric>till-infections</metric>
    <metric>staff-infections</metric>
    <metric>infected-customers</metric>
    <metric>susceptible-customers</metric>
    <metric>infectible-customers</metric>
    <metric>lost-customers</metric>
    <metric>max-shoppers</metric>
    <metric>max-shopq-time</metric>
    <metric>max-tillq-time</metric>
    <metric>day</metric>
    <metric>shopped</metric>
    <metric>shopped1</metric>
    <metric>shopped2</metric>
    <metric>shopped3</metric>
    <metric>total-shopq-time</metric>
    <metric>total-shop-time</metric>
    <metric>total-tillq-time</metric>
    <metric>shopq-time1</metric>
    <metric>shopq-time2</metric>
    <metric>shopq-time3</metric>
    <metric>shop-time1</metric>
    <metric>shop-time2</metric>
    <metric>shop-time3</metric>
    <metric>tillq-time1</metric>
    <metric>tillq-time2</metric>
    <metric>tillq-time3</metric>
    <enumeratedValueSet variable="v2-coverage">
      <value value="39.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infect-staff?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prevalence">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="v1-coverage">
      <value value="49"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="till-service-speed">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="step-size">
      <value value="35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ss-distribution">
      <value value="&quot;More Contacts&quot;"/>
      <value value="&quot;Fewer Contacts&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-parameter">
      <value value="&quot;base&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="usa-level">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="vaccine-scenario">
      <value value="&quot;Standard Vaccine Schedule&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distancing?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity-limit">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="staff-testing">
      <value value="&quot;None&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitization">
      <value value="&quot;Entrance&quot;"/>
      <value value="&quot;Entrance and Tills&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
