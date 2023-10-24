
sizeX=30; # Wielkość mapy (długość)
sizeY=20; # Wielkość mapy (szerokość)

posX=6; # Początkowa pozycja głowy węża (koordynat X)
posY=6; # Początkowa pozycja głowy węża (koordynat Y)

fixedPosX=(6 6); # Pozycja ciała węża (X)
fixedPosY=(7 8); # Pozycja ciała węża (Y)

foodX=10; # Pierwsza pozycja jedzenia (X)
foodY=6; # Pierwsza pozycja jedzenia (Y)

game() {
    clear; # Wyczyszczenie ekranu
    size=${#fixedPosX[@]}; # Ustawienie zmiennej size na wielkość ciała węża
    for((y=0; y<$sizeY; y++)) do # Robimy pęle na koordynat y
        for((x=0; x<$sizeX; x++)) do # Robimy pętle na koordynat x
            printed=false; # Zmienna pomocnicza
            for((i=0; i<$size; i++)) do # Robimy pętle, żeby uzyskać dostęp do każdego elementu ciała węża
                if [ $x -eq ${fixedPosX[$i]} ] && [ $y -eq ${fixedPosY[$i]} ] # Jeżeli akurat zmienna x i y z poprzednich pętl jest równa zmiennej x i y obecnie rozpatrywanego ciała węża, to wyświetlamy "O"
                then
                    printed=true; # Ustawiamy zmienną pomocniczą na true, która powie programowi, że już coś wyświetliliśmy
                    echo -n "O"; # echo -n oznacza, że wyświetlamy coś w tej samej linii
                fi
            done
            if [ "$printed" = true ] # Jeżeli zmienna printed jest ustawiona na true...
            then
                continue; # Jeżeli wyświetliliśmy już część węża, to nie chcemy wyświetlać części mapy ani sprawdzać, czy w danej pozycji jest głowa węża
            fi
            if [ $x -eq $posX ] && [ $y -eq $posY ] # Sprawdzamy, czy zmienna x i y jest równa pozycji x i y głowy węża - jeżeli tak wyświetlamy w tej samej linii O
            then
                echo -n "O";
            elif [ $x -eq $foodX ] && [ $y -eq $foodY ] # Sprawdzamy, czy zmienna x i y jest równa pozycji x i y jedzenia - jeżeli tak wyświetlamy w tej samej linii $ (jedzenie)
            then
                echo -n "$";
            else # Jeżeli nic nie ma na danej pozycji (ciała, głowy, jedzenia) to wyświetlamy spację - pusty znak na mapie
                echo -n " ";
            fi
        done
        echo
    done
    echo "Punkty: $((size-2))"; # Wyświetlanie punktów. Odejmujemy 2, ponieważ gracz zaczyna od takiej długości
    oldPosX=$posX; # Ustawiamy stare pozycje
    oldPosY=$posY;
    oldLastX=${fixedPosX[$((size-1))]}; # Ustawiamy starą pozycję ostatniego elementu ciała
    oldLastY=${fixedPosY[$((size-1))]};
    # RUSZANIE SIĘ GŁOWY - używamy ciągle if-elif, żeby wąż wykonał maksymalnie 1 ruch (nie chodził po skosie)
    if [ $posX -lt $foodX ] # posX to aktualna pozycja głowy (x). Bierzemy pod uwagę przypadek, gdy pozycja głowy (x) < pozycja jedzenia (x)
    then
        if [ ${fixedPosX[0]} -eq $((posX+1)) ] # Jeżeli w miejscu, gdzie wąż potrzebuje skręcić znajduje się ciało węża (pierwszy element ciała) to wąż zrobi unik, aby nie "wejść w siebie"
        then
            posY=$((posY+1)); # Przesuwamy węża o 1 niżej, aby uniknąć kolizji z własnym ciałem
        else
            posX=$((posX+1)); # Jeżeli nie ma przeszkód, dodajemy 1 do pozycji x głowy węża
        fi
    elif [ $posX -gt $foodX ] # Tutaj bierzemy pod uwagę przypadek, gdy pozycja głowy (x) > pozycja jedzenia (x)
    then
        if [ ${fixedPosX[0]} -eq $((posX-1)) ] # Tak samo sprawdzamy, czy w miejscu gdzie miałby się ruszyć wąż jest ciało. Jeżeli jest, wąż wykona unik (przejdzie 1 pole niżej)
        then
            posY=$((posY+1));
        else
            posX=$((posX-1)); # Jeżeli nie ma przeszkód w postaci ciała, odejmujemy 1 od pozycji x głowy węża
        fi
    elif [ $posY -lt $foodY ] # Bierzemy pod uwagę przypadek, gdy pozycja głowy (y) < pozycja jedzenia (y)
    then
        if [ ${fixedPosY[0]} -eq $((posY+1)) ] # Dokładnie tak samo jak wcześniej sprawdzamy przeszkodę
        then
            posX=$((posx+1)); # Jeżeli jest przeszkoda w postaci ciała, to wąż wykona unik przesuwając się w prawo
        else
            posY=$((posY+1)); # Jeżeli nie ma przeszkód, wąż przesunie się niżej
        fi
    elif [ $posY -gt $foodY ] # Pozycja głowy (y) > pozycja jedzenia (y)
    then
        if [ ${fixedPosY[0]} -eq $((posY-1)) ] # Dokładnie tak samo jak wyżej
        then
            posX=$((posx+1));
        else
            posY=$((posY-1)); # Wąż przesuwa się o 1 pole wyżej
        fi
    fi
    # RUSZANIE SIĘ CIAŁA
    for((i=$((size-1)); i>=0; i--)) do
        if [ $((i-1)) -eq -1 ] # Jeżeli nie ma już elementu bliższego głowy
        then
            fixedPosX[$i]=$oldPosX; # Ustawiamy element ciała na starą pozycję głowy
        else
            fixedPosX[$i]=${fixedPosX[$i-1]}; # Jeżeli jest element, który jest jeszcze bliżej głowy, to ustawiamy pozycję branego pod uwagę elementu na pozycję elementu bliższego głowy
        fi
    done
    for((i=$((size-1)); i>=0; i--)) do # Pętla działa dokładnie tak samo jak ta wyżej, ale w przypadku koordynatu y, nie x
        if [ $((i-1)) -eq -1 ]
        then
            fixedPosY[$i]=$oldPosY;
        else
            fixedPosY[$i]=${fixedPosY[$i-1]};
        fi
    done
    if [ $posX -eq $foodX ] && [ $posY -eq $foodY ] # Sprawdzanie, czy główka węża jest na jedzeniu
    then
        fixedPosX+=($oldLastX); # Rozszerzanie długości węża
        fixedPosY+=($oldLastY);
        foodX=$((RANDOM % sizeX + 1)); # Ustawianie losowej pozycji jedzenia (X)
        foodY=$((RANDOM % sizeY + 1)); # Ustawianie losowej pozycji jedzenia (Y)
    fi
}

update() {
    while true; do # Robimy nieskończoną pętlę, by gra nigdy się nie zakończyła
        game; # Wywołujemy funkcję game
        sleep 0.5; # Ustawiamy delay, żeby wąż nie poruszał się za szybko
    done
}

update; # Wywołujemy funkcję update