package com.eweaver.app.substring;

public class SubString {
    public static String getSubString(String str, int start, int length){ 
        length += start; 
        int len = 0; 
        StringBuffer sb = new StringBuffer(); 
        int k = 0; 
        while(len < length && k < str.length()){ 
            char c = str.charAt(k++); 
            if(c>255){ 
                len += 2; 
                if(len > length)  
                    break; 
            } else{ 
                len += 1; 
            } 
            if(len <= start || len <= start+1){ 
                continue; 
            } 
            sb.append(c); 
        } 
        if(k == str.length()){ 
            return sb.toString() ; 
        } 
        return sb.toString(); 
    }

}
