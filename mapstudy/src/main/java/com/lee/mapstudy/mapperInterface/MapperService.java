package com.lee.mapstudy.mapperInterface;

import org.apache.ibatis.annotations.Mapper;

import com.lee.mapstudy.boardDto.MemberDto;

@Mapper
public interface MapperService {
	public boolean insert(MemberDto mdto);
}
