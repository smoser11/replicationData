#!/bin/bash
# Reorganize BHPS and UKHLS files into wave-specific folders

# Set the base directory (update if your extraction path is different)
BASE_DIR="$HOME/Downloads/UKDA-6614-stata/stata/stata13_se"
DEST_DIR="/Users/sm38679/Documents/GitHub/replicationData/Replication_Data_for_Happiness_and_Voting/Raw Data/BHPS"

# Create destination directory
mkdir -p "$DEST_DIR"

echo "========================================="
echo "Reorganizing BHPS files into wave folders"
echo "========================================="

# BHPS waves: a through r (18 waves)
# Wave letter mapping: a=1, b=2, c=3, ..., r=18
waves=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r")

for i in "${!waves[@]}"; do
    wave_num=$((i + 1))
    wave_letter="${waves[$i]}"

    echo "Processing BHPS Wave $wave_num (letter: $wave_letter)..."

    # Create wave folder
    mkdir -p "$DEST_DIR/bhps_w$wave_num"

    # Copy all files starting with b{wave_letter}_ to the wave folder
    if [ -d "$BASE_DIR/bhps" ]; then
        cp "$BASE_DIR/bhps/b${wave_letter}_"*.dta "$DEST_DIR/bhps_w$wave_num/" 2>/dev/null

        # Check if files were copied
        file_count=$(ls -1 "$DEST_DIR/bhps_w$wave_num/" 2>/dev/null | wc -l)
        echo "  → Copied $file_count files to bhps_w$wave_num/"
    fi
done

echo ""
echo "========================================="
echo "Reorganizing UKHLS files into wave folders"
echo "========================================="

# UKHLS waves: a through n (14 waves based on your listing)
ukhls_waves=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n")

for i in "${!ukhls_waves[@]}"; do
    wave_num=$((i + 1))
    wave_letter="${ukhls_waves[$i]}"

    echo "Processing UKHLS Wave $wave_num (letter: $wave_letter)..."

    # Create wave folder
    mkdir -p "$DEST_DIR/ukhls_w$wave_num"

    # Copy all files starting with {wave_letter}_ to the wave folder
    if [ -d "$BASE_DIR/ukhls" ]; then
        cp "$BASE_DIR/ukhls/${wave_letter}_"*.dta "$DEST_DIR/ukhls_w$wave_num/" 2>/dev/null

        # Check if files were copied
        file_count=$(ls -1 "$DEST_DIR/ukhls_w$wave_num/" 2>/dev/null | wc -l)
        echo "  → Copied $file_count files to ukhls_w$wave_num/"
    fi
done

echo ""
echo "========================================="
echo "Reorganization Complete!"
echo "========================================="
echo "Files are now organized in: $DEST_DIR"
echo ""
echo "Verifying structure:"
ls -d "$DEST_DIR"/bhps_w* "$DEST_DIR"/ukhls_w* 2>/dev/null | head -10
echo "..."
echo ""
echo "Total BHPS wave folders: $(ls -d "$DEST_DIR"/bhps_w* 2>/dev/null | wc -l)"
echo "Total UKHLS wave folders: $(ls -d "$DEST_DIR"/ukhls_w* 2>/dev/null | wc -l)"
