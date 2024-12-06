#!/usr/bin/env sh
# Options: County, CountyPlus, Plain
typeOfSetup="County"

if [ ! -d "$data" ]; then
    mkdir data notebooks reports
    cd data
    mkdir raw interim processed
    cd raw
    mkdir shapefiles NLCD
    cd shapefiles
    mkdir Anderson Blount Campbell Claiborne Cocke Grainger Hamblen Jefferson Knox Loudon Monroe Morgan Roane Scott Sevier Union
    mkdir counties states places
    echo "about to move to anderson"
        ls
   # if [ "$typeOfSetup" == "County" ]; then

#        mkdir Anderson Blount Campbell Claiborne Cocke Grainger Hamblen Jefferson Knox Loudon Monroe Morgan Roane Scott Sevier Union
 #       if [ $typeOfSetup == 'CountyPlus' ]; then
        

            cd Anderson
            mkdir Clinton Norris OakRidge RockyTop
            cd ..
            cd Blount
            mkdir Alcoa Maryville Friendsville Rockford Louisville Townsend
            cd ..
            cd Campbell
            mkdir Caryville Jacksboro Jellico LaFollette
            cd ..

            cd Claiborne
            mkdir CumberlandGap Harrogate NewTazewell Tazewell
            cd ..

            cd Cocke
            mkdir Newport Parrottsville
            cd ..

            cd Grainger
            mkdir BeanStation Rutledge Blaine
            cd ..


            cd Hamblen
            mkdir Morristown
            cd ..

            cd Jefferson
            mkdir Baneberry Dandridge JeffersonCity NewMarket WhitePine
            cd ..

            cd Knox
            mkdir Knoxville Farragut
            cd ..

            cd Loudon
            mkdir Loudon Lenoir Greenback Philadelphia
            cd ..

            cd Monroe
            mkdir Madisonville Sweetwater TellicoPlains Vonore
            cd ..

            cd Morgan
            mkdir Oakdale Sunbright Wartburg
            cd ..

            cd Roane
            mkdir Harriman Kingston Rockwood OliverSprings
            cd ..

            cd Scott
            mkdir Huntsville Oneida Winfield
            cd ..

            cd Sevier
            mkdir Gatlinburg PigeonForge PittmanCenter Sevierville
            cd ..

            cd Union
            mkdir Luttrell Maynardville Plainview
            cd ..

   #     fi
 #   fi
    cd ..
    cd ..
    ls
    cd interim
    mkdir ETDDShapefiles

    cd ..
    cd processed
    mkdir shapefiles
 #       if $typeOfSetup == 'County'; then
cd shapefiles
        mkdir Anderson Blount Campbell Claiborne Cocke Grainger Hamblen Jefferson Knox Loudon Monroe Morgan Roane Scott Sevier Union places
   #     if $typeOfSetup == 'CountyPlus'; then
            cd Anderson
            mkdir Clinton Norris OakRidge RockyTop
            cd ..
            cd Blount
            mkdir Alcoa Maryville Friendsville Rockford Louisville Townsend
            cd ..
            cd Campbell
            mkdir Caryville Jacksboro Jellico LaFollette
            cd ..

            cd Claiborne
            mkdir CumberlandGap Harrogate NewTazewell Tazewell
            cd ..

            cd Cocke
            mkdir Newport Parrottsville
            cd ..

            cd Grainger
            mkdir BeanStation Rutledge Blaine
            cd ..


            cd Hamblen
            mkdir Morristown
            cd ..

            cd Jefferson
            mkdir Baneberry Dandridge JeffersonCity NewMarket WhitePine
            cd ..

            cd Knox
            mkdir Knoxville Farragut
            cd ..

            cd Loudon
            mkdir Loudon Lenoir Greenback Philadelphia
            cd ..

            cd Monroe
            mkdir Madisonville Sweetwater TellicoPlains Vonore
            cd ..

            cd Morgan
            mkdir Oakdale Sunbright Wartburg
            cd ..

            cd Roane
            mkdir Harriman Kingston Rockwood OliverSprings
            cd ..

            cd Scott
            mkdir Hunstville Oneida Winfield
            cd ..

            cd Sevier
            mkdir Galinburg PigeonForge PittmanCenter Sevierville
            cd ..

            cd Union
            mkdir Luttrell Maynardville Plainview
            cd ..


    #    fi
   # fi


    cd ..
    cd ..

fi
