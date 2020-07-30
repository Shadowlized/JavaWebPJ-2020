package com;

public class PagesProperties {
    public String getPrintPagesString(int pagePicNumber, int picCount){
        int pageCount = 1;
        if((picCount % pagePicNumber == 0) && picCount != 0){
            pageCount = picCount / pagePicNumber;
        } else if(picCount == 0){
            pageCount = 0;
        } else {
            pageCount = (picCount / pagePicNumber) + 1;
        }
        pageCount = Math.min(pageCount, 5); //最多取五页
        String str = " ";
        if(pageCount >= 1)
            str = "<h5><a onclick='funct1()'><span>&nbsp;&nbsp;1&nbsp;&nbsp;</span></a>";
        if(pageCount >= 2)
            str += "<a onclick='funct2()'><span>&nbsp;&nbsp;2&nbsp;&nbsp;</span></a>";
        if(pageCount >= 3)
            str += "<a onclick='funct3()'><span>&nbsp;&nbsp;3&nbsp;&nbsp;</span></a>";
        if(pageCount >= 4)
            str += "<a onclick='funct4()'><span>&nbsp;&nbsp;4&nbsp;&nbsp;</span></a>";
        if(pageCount == 5)
            str += "<a onclick='funct5()'><span>&nbsp;&nbsp;5&nbsp;&nbsp;</span></a>";
        str += "</h5>";

        return str;
    }
}
