/**
 * Type Engine v1.0
 * @author <mdadalkhan@gmail.com>
 * */

/**
 * Input:
 *      input string: "A quick brown fox jumps over the lazy dog"
 *        Time Limit: T 
 *        StrokesPerWord: SPW
 * Output = Calculate accuracy & Speed where Word
 * 
 * */

"A quick brown fox jumps over the lazy dog"
Converted to Words
refWords = ["A", "qucik", "brown", "fox", "jumps", "over", "the", "lazy", "dog"
refWordIndex = 0

While refWordIndex < refWords.length 
CorrectStrokes = 0
WrongStrokes   = 0
Case 1: user typed A     Ans: Correct Stroke 1, Wrong 0 ;
Case 2: user typed fox   Ans: Skipped brown but fox is correct so Correct Stroke = 3 Wrong Stroke = 5
Case 3: user typed do    Ans: Skipped jumps, over, the, so Correct Stroke = 2 due to dog do match and Wrong Stroke = 12  


02. Calculate, Total CorrectStrokes
    Calculate, Total Wrong Strokes
    Calculate, Total Strokes = Correct + Wrong
    Calculate, Accuracy = (Correct Strokes/Total Strokes)*100%
    Calculate, WPM      = (TotalStrokes/StrokesPerWord)/(T/60) 
/*---------------------------------------------------------------------------------------------------------------------------*/

          







