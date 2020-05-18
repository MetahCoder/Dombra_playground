import UIKit

// Content - the structure, where all of the app's data is stored
public struct Content {
    public static var silverColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.8)
    public static var highlightColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
    
    public static var firstNotes = ["A", "G#", "G", "F#", "F", "E", "D#", "D", "C#", "C", "B", "A#", "A", "G#", "G", "F#", "F", "E", "D#"]
    public static var secondNotes = ["D", "C#", "C", "B", "A#", "A", "G#", "G", "F#", "F", "E", "D#", "D", "C#", "C", "B", "A#", "A", "G#"]
    public static var firstOpenNote = "D"
    public static var secondOpenNote = "G"
    
    public static var tempos = ["Grave": 1.36, "Largo": 1.25, "Adagio": 1.15, "Lento": 1.11, "Andante": 0.92, "Moderato": 0.68, "Animato": 0.56, "Allegro": 0.45, "Vivo": 0.36, "Presto": 0.31]

    public static var infoText = """
        The Dombra - is a Kazakh national string instrument. People perform songs with it, but they usually play short tunes. The melody, which is played on the Dombra, is called "Kui".

        The Dombra plays a significant role in Kazakh culture. The traditional proverb states: "The real Kazakh is not a Kazakh man, but the Dombra". These words truly represent how inextricably the instrument is intertwined with Kazakh history, superstitions, and customs.

        You can better understand the soul of the Kazakh people by hearing the Dombra.

        This application allows you not only to become acquainted with the magic of the instrument, but also to try to play it.

        Wish you all the best in the journey of discovering a fascinating world of the steppe's sounds!
    """
    
}
