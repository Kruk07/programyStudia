package kodowanie;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.codec.binary.Base64;

public class Encryptor {
	public static byte[] toByteArray(String s) {
	    return DatatypeConverter.parseHexBinary(s);
	}
    public static String encrypt(String key, String initVector, String value) {
        try {
            IvParameterSpec iv = new IvParameterSpec(toByteArray(initVector));
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv);

            byte[] encrypted = cipher.doFinal(value.getBytes());
            System.out.println("encrypted string: "
                    + Base64.encodeBase64String(encrypted));

            return Base64.encodeBase64String(encrypted);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
    }
    public static String decrypt(String key, String initVector, String encrypted) throws BadPaddingException {
        try {
;

            IvParameterSpec iv = new IvParameterSpec(toByteArray(initVector));
            SecretKeySpec skeySpec = new SecretKeySpec(toByteArray(key), "AES");
                    Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);

            byte[] original = cipher.doFinal(Base64.decodeBase64(encrypted));
            
            return new String(original, "UTF-8");
        } catch (Exception ex) {
            //ex.printStackTrace();
          
            throw new BadPaddingException();
        }


    }

    static int sprawdzCzyOK(String napis){
    	//char[] znaki={' ','A','a','E','e','I','i','O','o','U','u','Q','q','W','w',' ','Í','R','r','T','t','Y','y','”','Û','P','p','•','π','S','s','å','ú','D','d','F','f','G','g','H','h','J','j','K','k','L','l','£','≥','Z','z','Ø','ø','X','x','è','ü','C','c','∆','Ê','V','v','B','b','N','n','—','Ò','M','m','0','1','2','3','4','5','6','7','8','9','"','\'','!','?',',','.',';',':','\0','(',')','%','-'};
    	char[] znaki={' ','"','0','1','2','3','4','5','6','7','8','9','A','a','π','B','b','C','c','∆','Ê','D','d','E','e',' ','Í','F','f','G','g','H','h','I','i','J','j','K','k','L','l','£','≥','M','m','N','n','—','Ò','O','o','P','p','R','r','S','s','å','ú','T','t','U','u','”','Û','Q','q','V','v','W','w','X','x','Y','y','Z','z','Ø','ø','è','ü','(',')','[',']','{','}',',','.','-',':','~',';','?','/','%','\'','\0'};
    	boolean znak;
    	for (int i=0;i<napis.length()-2;i++){
    		znak=false;
    		for (int j=0;j<znaki.length;j++){
    			if(napis.charAt(i)==znaki[j]){
    				znak=true;
    				break;
    			}
    		}
    		if (znak==false){
    			return 0;
    		}
    	}
    	return 1;
    	
    }
    
    public static void main(String[] args) throws FileNotFoundException, BadPaddingException {
    	int begin=Integer.parseInt(args[0]);
    	int end=Integer.parseInt(args[1]);
    	//String[] letters={"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"};
    	String[] letters={"f","e","d","c","b","a","9","8","7","6","5","4","3","2","1","0"};
    	System.out.println("Szukam od: "+letters[begin]+ " do "+ letters[end]);
    	String sufikskey="59c32a8551079ba1f2b8ae64b043969817a04805514b46fc33e89e03";
    	PrintWriter zapis = new PrintWriter("2wynik"+begin +".txt");
    	zapis.print("DLACZEGO TO NIE DZIALA!?");
        //String key = "7477e315c60b2a98fce9398ed6814cc0e87d6784ed34458e4ba00de6a5f23d9b"; // 128 bit key
        //String initVector = "RandomInitVector"; // 16 bytes IV
        String key="";
        //String message="";
        String initVector = "8aaedd5ea73bba58427ae1f4b321ba38"; // 16 bytes IV
        String message= "9eZ2tqPdKAzx46JcOQp+Hrc7rL3tIb5bx3/bERqYuHF9zh6AI/6SqyNWmdm+lgZNJUX3REcghwqh8OkV+Q6iJg==";

        double licznik=1;
        double wszystkie= (end-begin)*letters.length;
        double zostalo=0;
        zapis.println("ROZPOCZETO: kod szukany od: "+ begin+" do "+end);
        zapis.close();
    	for(int i=begin;i<end;i++){
        	for(int j=0;j<letters.length;j++){
        		licznik++;
            	for(int k=0;k<letters.length;k++){
                	for(int l=0;l<letters.length;l++){
                    	for(int o=0;o<letters.length;o++){
                        	for(int p=0;p<letters.length;p++){
                            	for(int q=0;q<letters.length;q++){
                                	for(int r=0;r<letters.length;r++){
                                		//System.out.println(letters[i]+letters[j]+letters[k]+letters[l]+letters[o]+letters[p]+letters[q]+letters[r]+sufikskey);
                                        key = letters[i]+letters[j]+letters[k]+letters[l]+letters[o]+letters[p]+letters[q]+letters[r]+sufikskey;  // 128 bit key
                                        //System.out.println(decrypt(key, initVector,message));
                                        try{
                                            String z=decrypt(key, initVector,message); 
                                            if(sprawdzCzyOK(z)==1){
                                            	Date currentDate = new Date();
                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
                                            	String dateString = dateFormat.format(currentDate);
                                            	PrintWriter zapis2 = new PrintWriter("2wynik"+begin +".txt");
                                            	zapis2.println(dateString + " Klucz: "+ key+ " wiadomosc: "+ z);
                                            	zapis2.close();
                                            	System.out.println(dateString+ " Klucz: "+ key+ " wiadomosc: "+ z);
                                            }
                                        	z=null;
                                        }catch (BadPaddingException ex){
                                        	continue;                   	
                                        }	                                         
                                	}
                            	}
                        	}
                    	}
                	}
            	}
        		zostalo=(licznik/wszystkie)*100;
            	System.out.println("WYKONANO:"+ zostalo+ "%");
        	}
    	}
        
    	Date currentDate = new Date();
    	SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	String dateString = dateFormat.format(currentDate);
    	System.out.println("ZAKONCZONO DZIALANIE "+dateString);


    }
}