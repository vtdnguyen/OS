#! bash/bin
ANS_FILE="ans.txt"
HIST_FILE="hist.txt"
MAX_OPERATIONS=5
ANS() {
    if [ -f "$ANS_FILE" ]; then
        echo $(<"$ANS_FILE")
    else
        echo "No ans available"
    fi
}
HIST() {
    if [ -f "$HIST_FILE" ]; then
        tail -n $MAX_OPERATIONS "$HIST_FILE"
    else
        echo "No history available"
    fi
}
save_hist(){
    local operation="$1"
    # Add the new operation to the file
    echo "$operation" >> "$HIST_FILE"
    # Keep only the latest MAX_OPERATIONS operations
    tail -n $MAX_OPERATIONS "$HIST_FILE" > "$HIST_FILE.tmp" && mv "$HIST_FILE.tmp" "$HIST_FILE"
}
check_operation_type() {
    operation="$1"
    # Check if operation is addition
    if [[ "$operation" == "+" ]]; then
        echo "+"
    # Check if operation is subtraction
    elif [[ "$operation" == "-" ]]; then
        echo "-"
    # Check if operation is multiplication
    elif [[ "$operation" == "*" ]]; then
        echo "*"
    # Check if operation is division
    elif [[ "$operation" == "/" ]]; then
        echo "/"
    # Check if operation is modulo
    elif [[ "$operation" == "%" ]]; then
        echo "%"
    else
        echo "SYNTAX ERROR"
    fi
}

checking_1() {
	operator="$1"
	numbers="$2"
	    if [ $(echo "$numbers" | wc -w) -ne 2 ]; then
		echo "SYNTAX ERROR"
		return
	    fi
	    
	    type=$(check_operation_type "$operator")
	
	    if [[ "$type" == "SYNTAX ERROR" ]]; then
		echo "SYNTAX ERROR"
		return
	    fi
}

checking() {
	operator="$1"
	numbers="$2"
	check=$(checking_1 "$operator" "$numbers")
	    if [[ "$check" == "SYNTAX ERROR" ]]; then
		echo "SYNTAX ERROR"
		return
	    fi
	    
	    # Extract
	    num1=$(echo "$numbers" | awk '{print $1}')
	    num2=$(echo "$numbers" | awk '{print $2}')

	    # KIEM TRA 2 SO
	    if ! [[ "$num1" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
		echo "SYNTAX ERROR"
		return
	    fi

	    if ! [[ "$num2" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
		echo "SYNTAX ERROR"
		return
	    fi

	    # Check if division by zero
	    if [[ "$operator" == "/" && "$num2" -eq 0 ]]; then
		echo "MATH ERROR"
		return
	    fi
}
calculate() {
    	operation="$1"
    			
    	    operator=$(echo "$operation" | sed 's/[0-9]//g' | tr -d '\n')
	    numbers=$(echo "$operation" | sed 's/[^0-9.]/ /g')
	    echo "$operator $numbers"
	    ################## 
	    check=$(checking "$operator" "$numbers")
	    if [[ "$check" == "SYNTAX ERROR" ]]; then
		echo "SYNTAX ERROR"
		return
	    elif [[ "$check" == "MATH ERROR" ]]; then
		echo "MATH ERROR"
		return
	    fi
	    ##################
	    
    	#CALCULATE
	if [[ "$operator" == "%" ]]; then 
		result=$(echo "scale=0; $operation" | bc)
	else    
        	result=$(echo "scale=2; $operation" | bc)
        fi
        echo "$result" > "$ANS_FILE"
        save_hist "$operation=$result"
        echo "$result"
}
ans_checking(){
	operation="$1"
	ans=$(ANS)
	if [[ $operation == *ANS ]]; then 
		rest="${operation%"ANS"}"
		echo "$rest$ans"
		return
	elif [[ $operation == ANS* ]]; then 
		rest="${operation#"ANS"}"
		echo "$ans$rest"
		return
	else
		echo "$operation"
		return
	fi
}
				#################
				###   MAIN    ###
				#################
				
while true; do
	clear
	read -p ">> " operation
	
	if [[ "$operation" == "EXIT" || "$operation" == "exit" ]]; then
		break
	elif [[ "$operation" == "ANS" ]]; then
		ANS
	elif [[ "$operation" == "HIST" ]]; then
		HIST
	else
		operation_modified=$(ans_checking "$operation")
		calculate $operation_modified
	fi
	
	read -n 1 -s -r -p "Press any key to start a new calculation..."
done

