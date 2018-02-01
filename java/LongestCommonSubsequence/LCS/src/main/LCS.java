package main;

import java.util.Random;

import org.jfree.ui.RefineryUtilities;

public class LCS {
	static int op;
    public static void main(String[] args) {
    	int liczba_powtorzen=10;
    	int [] ilosc_operacji=new int [liczba_powtorzen];
    	for(int i=1;i<=liczba_powtorzen;i++){
    		op=0;
        	String s1=losujCiagZnakow(i); 
        	String s2=losujCiagZnakow(i);
        	LongestCommonSubsequence(s1,s2);
        	ilosc_operacji[i-1]=op;
    	}
    	Chart wykres= new Chart("LCS","LCS",ilosc_operacji);
	     wykres.pack( );          
	      RefineryUtilities.centerFrameOnScreen( wykres );          
	      wykres.setVisible( true ); 
    }
    
    private static String losujCiagZnakow(int i) {
        Random rand = new Random();
        String napis="";
    	for(int j=1;j<=i;j++){
            char los = (char)(rand.nextInt(26)+97);
            napis+=los;
    	}

		return napis;
	}

	public static void LongestCommonSubsequence (String s1, String s2){
    	   String x = s1;
           String y = s2;
           int M = x.length();
           int N = y.length();


           int[][] opt = new int[M+1][N+1];


           for (int i = M-1; i >= 0; i--) {
               for (int j = N-1; j >= 0; j--) {
                   if (x.charAt(i) == y.charAt(j)){
                       opt[i][j] = opt[i+1][j+1] + 1;               	   
                   }

                   else {
                       opt[i][j] = Math.max(opt[i+1][j], opt[i][j+1]);               	   
                   }
                   op++;
               }
           }


           int i = 0, j = 0;
           while(i < M && j < N) {
               if (x.charAt(i) == y.charAt(j)) {
                   System.out.print(x.charAt(i));
                   i++;
                   j++;
               }
               else if (opt[i+1][j] >= opt[i][j+1]){
            	   i++;
               }
               else {
            	   j++;
               }
           }
           System.out.println();
    }

}