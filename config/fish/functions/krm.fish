# krm - Remove a kanji from the flashcards list
# Usage: krm <kanji>

function krm
    # Check if kanji argument is provided
    if test (count $argv) -lt 1
        echo "Error: Please provide a kanji to remove"
        echo "Usage: krm <kanji>"
        return 1
    end
    
    set -l kanji $argv[1]
    set -l voca_file ~/Nextcloud/flashcards/voca.txt
    
    # Check if the file exists
    if test ! -f "$voca_file"
        echo "Error: Flashcards file not found: $voca_file"
        return 1
    end
    
    # Check if the kanji exists in the file
    if grep -q "^$kanji\$" "$voca_file" 2>/dev/null
        # Create a temporary file
        set -l temp_file (mktemp)
        
        # Remove the kanji from the file
        grep -v "^$kanji\$" "$voca_file" > "$temp_file"
        
        # Replace the original file with the temporary file
        mv "$temp_file" "$voca_file"
        
        echo "Removed '$kanji' from the flashcards list"
    else
        echo "Kanji '$kanji' not found in the flashcards list"
        return 1
    end
end