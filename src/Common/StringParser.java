package Common;

import java.util.ArrayList;
import java.util.List;

public class StringParser {
	
    public static List<String> splitString(String combinedString) {
    	
        List<String> resultList = new ArrayList<>();
        int index = 0;

        while (index < combinedString.length()) {
            // 4바이트 길이 읽기
            String lengthStr = combinedString.substring(index, index + 4);
            int length = Integer.parseInt(lengthStr); 	// 문자열을 int로 변환
            index += 4; 	// 길이를 읽었으므로 인덱스 이동
            
            // 길이에 해당하는 문자열 읽기
            String value = combinedString.substring(index, index + length);
            resultList.add(value);		 // 리스트에 추가
            index += length;	 // 다음 문자열로 이동
        }
        
        return resultList;
    }
}