Shader "FX/Water (simple)" {
Properties {
	_horizonColor ("Horizon color", COLOR)  = ( .172 , .463 , .435 , 0)
	_WaveScale ("Wave scale", Range (0.02,0.15)) = .07
	_ColorControl ("Reflective color (RGB) fresnel (A) ", 2D) = "" { }
	_ColorControlCube ("Reflective color cube (RGB) fresnel (A) ", Cube) = "" { TexGen CubeReflect }
	_BumpMap ("Waves Bumpmap (RGB) ", 2D) = "" { }
	WaveSpeed ("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
	_MainTex ("Fallback texture", 2D) = "" { }
}

#LINE 54

	
// -----------------------------------------------------------
// Fragment program

Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {

Program "" {
// Vertex combos: 1
//   opengl - ALU: 14 to 14
//   d3d9 - ALU: 14 to 14
// Fragment combos: 1
//   opengl - ALU: 9 to 9, TEX: 3 to 3
//   d3d9 - ALU: 8 to 8, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Bind "vertex", Vertex
Local 1, [_ObjectSpaceCameraPos]
Local 2, ([_WaveScale],0,0,0)
Local 3, [_WaveOffset]
"!!ARBvp1.0
# 14 ALU
PARAM c[8] = { { 0.40000001, 0.44999999 },
		program.local[1..3],
		state.matrix.mvp };
TEMP R0;
TEMP R1;
ADD R1.xyz, -vertex.position, c[1];
MUL R0.xy, vertex.position.xzzw, c[2].x;
ADD R0, R0.xyxy, c[3];
DP3 R1.w, R1, R1;
MUL result.texcoord[0].xy, R0, c[0];
RSQ R0.x, R1.w;
MUL result.texcoord[2].xyz, R0.x, R1.xzyw;
DP4 R0.x, vertex.position, c[6];
MOV result.texcoord[1].xy, R0.wzzw;
DP4 result.position.w, vertex.position, c[7];
MOV result.position.z, R0.x;
DP4 result.position.y, vertex.position, c[5];
DP4 result.position.x, vertex.position, c[4];
MOV result.fogcoord.x, R0;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex", Vertex
Local 4, [_ObjectSpaceCameraPos]
Local 5, ([_WaveScale],0,0,0)
Local 6, [_WaveOffset]
Matrix 0, [glstate_matrix_mvp]
"vs_1_1
; 14 ALU
def c7, 0.40000001, 0.44999999, 0, 0
dcl_position v0
add r1.xyz, -v0, c4
mul r0.xy, v0.xzzw, c5.x
add r0, r0.xyxy, c6
dp3 r1.w, r1, r1
mul oT0.xy, r0, c7
rsq r0.x, r1.w
mul oT2.xyz, r0.x, r1.xzyw
dp4 r0.x, v0, c2
mov oT1.xy, r0.wzzw
dp4 oPos.w, v0, c3
mov oPos.z, r0.x
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oFog, r0.x
"
}

SubProgram "opengl " {
Keywords { }
Local 0, [_horizonColor]
SetTexture [_BumpMap] {2D}
SetTexture [_ColorControl] {2D}
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
OPTION ARB_fog_exp2;
# 9 ALU, 3 TEX
PARAM c[2] = { program.local[0],
		{ 1 } };
TEMP R0;
TEMP R1;
TEX R1.xyz, fragment.texcoord[1], texture[0], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
ADD R0.xyz, R0, R1;
ADD R0.xyz, R0, -c[1].x;
DP3 R0.x, fragment.texcoord[2], R0;
MOV result.color.w, c[0];
TEX R0, R0.x, texture[1], 2D;
ADD R1.xyz, -R0, c[0];
MAD result.color.xyz, R0.w, R1, R0;
END
# 9 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Local 0, [_horizonColor]
SetTexture [_BumpMap] {2D}
SetTexture [_ColorControl] {2D}
"ps_2_0
; 8 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c1, -1.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xyz
texld r0, t1, s0
texld r1, t0, s0
add_pp r0.xyz, r1, r0
add_pp r0.xyz, r0, c1.x
dp3 r0.x, t2, r0
mov r0.xy, r0.x
texld r0, r0, s1
add_pp r1.xyz, -r0, c0
mad_pp r0.xyz, r0.w, r1, r0
mov_pp r0.w, c0
mov_pp oC0, r0
"
}

}
#LINE 86

	}
}

// -----------------------------------------------------------
// Radeon 9000

Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {
Program "" {
// Vertex combos: 1
//   opengl - ALU: 14 to 14
//   d3d9 - ALU: 14 to 14
SubProgram "opengl " {
Keywords { }
Bind "vertex", Vertex
Local 1, [_ObjectSpaceCameraPos]
Local 2, ([_WaveScale],0,0,0)
Local 3, [_WaveOffset]
"!!ARBvp1.0
# 14 ALU
PARAM c[8] = { { 0.40000001, 0.44999999 },
		program.local[1..3],
		state.matrix.mvp };
TEMP R0;
TEMP R1;
ADD R1.xyz, -vertex.position, c[1];
MUL R0.xy, vertex.position.xzzw, c[2].x;
ADD R0, R0.xyxy, c[3];
DP3 R1.w, R1, R1;
MUL result.texcoord[0].xy, R0, c[0];
RSQ R0.x, R1.w;
MUL result.texcoord[2].xyz, R0.x, R1.xzyw;
DP4 R0.x, vertex.position, c[6];
MOV result.texcoord[1].xy, R0.wzzw;
DP4 result.position.w, vertex.position, c[7];
MOV result.position.z, R0.x;
DP4 result.position.y, vertex.position, c[5];
DP4 result.position.x, vertex.position, c[4];
MOV result.fogcoord.x, R0;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex", Vertex
Local 4, [_ObjectSpaceCameraPos]
Local 5, ([_WaveScale],0,0,0)
Local 6, [_WaveOffset]
Matrix 0, [glstate_matrix_mvp]
"vs_1_1
; 14 ALU
def c7, 0.40000001, 0.44999999, 0, 0
dcl_position v0
add r1.xyz, -v0, c4
mul r0.xy, v0.xzzw, c5.x
add r0, r0.xyxy, c6
dp3 r1.w, r1, r1
mul oT0.xy, r0, c7
rsq r0.x, r1.w
mul oT2.xyz, r0.x, r1.xzyw
dp4 r0.x, v0, c2
mov oT1.xy, r0.wzzw
dp4 oPos.w, v0, c3
mov oPos.z, r0.x
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oFog, r0.x
"
}

}
#LINE 100


		Program "" {
			SubProgram {
				Local 0, [_horizonColor]

"!!ATIfs1.0
StartConstants;
	CONSTANT c0 = program.local[0];
EndConstants;

StartPrelimPass;
	SampleMap r0, t0.str;
	SampleMap r1, t1.str;
	PassTexCoord r2, t2.str;
	
	ADD r1, r0.bias, r1.bias;	# bump = bump1 + bump2 - 1
	DOT3 r2, r1, r2;			# fresnel: dot (bump, viewer-pos)
EndPass;

StartOutputPass;
 	SampleMap r2, r2.str;

	LERP r0.rgb, r2.a, c0, r2;	# fade in reflection
	MOV r0.a, c0.a;
EndPass;
"
#LINE 126
 
}
}
		SetTexture [_BumpMap] {}
		SetTexture [_BumpMap] {}
		SetTexture [_ColorControl] {}
	}
}

// -----------------------------------------------------------
//  Old cards

// three texture, cubemaps
Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0.5)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture * primary
		}
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix2]
			combine texture * primary + previous
		}
		SetTexture [_ColorControlCube] {
			combine texture +- previous, primary
			Matrix [_Reflection]
		}
	}
}

// dual texture, cubemaps
Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0.5)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture
		}
		SetTexture [_ColorControlCube] {
			combine texture +- previous, primary
			Matrix [_Reflection]
		}
	}
}

// single texture
Subshader {
	Tags { "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture, primary
		}
	}
}

}
