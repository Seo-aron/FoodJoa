package Common;

import java.util.ArrayList;
import java.util.List;

public class StringParser {
	
    public static List<String> parseStringWithLength(String combinedString) {
    	
        List<String> result = new ArrayList<>();
        
        int i = 0;        
        while (i < combinedString.length()) {
            int length = ((combinedString.charAt(i) & 0xFF) << 8) | (combinedString.charAt(i + 1) & 0xFF);
            
            i += 2;
            
            if (i + length <= combinedString.length()) {
                String str = combinedString.substring(i, i + length);
                result.add(str);
                
                i += length;
            } 
            else {
                break;
            }
        }
        
        return result;
    }
}