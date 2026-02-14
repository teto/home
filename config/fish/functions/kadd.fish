# kadd - Add a kanji to the flashcards list if it doesn't exist yet
# Usage: kadd <kanji>

function kadd
    # Check if kanji argument is provided
    if test (count $argv) -lt 1
        echo "Error: Please provide a kanji to add"
        echo "Usage: kadd <kanji>"
        return 1
    end
    
    set -l kanji $argv[1]
    set -l voca_file ~/Nextcloud/flashcards/voca.txt
    
    # Check if the kanji already exists in the file
    if grep -q "^$kanji\$" "$voca_file" 2>/dev/null
        echo "Kanji '$kanji' already exists in the flashcards list"
        return 0
    end
    
    # Add the kanji to the file
    echo "$kanji" >> "$voca_file"
    echo "Added '$kanji' to the flashcards list"
end