package com.lee.mapstudy.boardDto;

public class PagingContentDto {
	private int page; //현재 페이지 번호
	private int perPageNum; //페이지 당 보여줄 글 개수
	
	public PagingContentDto() {
		this.page = 1;
		this.perPageNum = 10;
	}
	
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		if(page <= 0) {
            this.page = 1;
            
        } else {
            this.page = page;
        }    
	}

	public int getPerPageNum() {
		return perPageNum;
	}

	public void setPerPageNum(int perPageNum) {
		this.perPageNum = perPageNum;
	}
	
}
