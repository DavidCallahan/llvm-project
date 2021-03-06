; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use(float)

; -(X * C) --> X * (-C)

define float @fmul_fneg(float %x) {
; CHECK-LABEL: @fmul_fneg(
; CHECK-NEXT:    [[R:%.*]] = fmul float [[X:%.*]], -4.200000e+01
; CHECK-NEXT:    ret float [[R]]
;
  %m = fmul float %x, 42.0
  %r = fsub float -0.0, %m
  ret float %r
}

; Fast math is not required, but it should be propagated.

define float @fmul_fneg_fmf(float %x) {
; CHECK-LABEL: @fmul_fneg_fmf(
; CHECK-NEXT:    [[R:%.*]] = fmul reassoc nsz float [[X:%.*]], -4.200000e+01
; CHECK-NEXT:    ret float [[R]]
;
  %m = fmul float %x, 42.0
  %r = fsub reassoc nsz float -0.0, %m
  ret float %r
}

; Extra use prevents the fold. We don't want to replace the fneg with an fmul.

define float @fmul_fneg_extra_use(float %x) {
; CHECK-LABEL: @fmul_fneg_extra_use(
; CHECK-NEXT:    [[M:%.*]] = fmul float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[M]]
; CHECK-NEXT:    call void @use(float [[M]])
; CHECK-NEXT:    ret float [[R]]
;
  %m = fmul float %x, 42.0
  %r = fsub float -0.0, %m
  call void @use(float %m)
  ret float %r
}

; Try a vector. Use special constants (NaN, INF, undef) because they don't change anything.

define <4 x double> @fmul_fneg_vec(<4 x double> %x) {
; CHECK-LABEL: @fmul_fneg_vec(
; CHECK-NEXT:    [[R:%.*]] = fmul <4 x double> [[X:%.*]], <double -4.200000e+01, double 0x7F80000000000000, double 0xFFF0000000000000, double 0x7FF8000000000000>
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %m = fmul <4 x double> %x, <double 42.0, double 0x7FF80000000000000, double 0x7FF0000000000000, double undef>
  %r = fsub <4 x double> <double -0.0, double -0.0, double -0.0, double -0.0>, %m
  ret <4 x double> %r
}

; -(X / C) --> X / (-C)

define float @fdiv_op1_constant_fneg(float %x) {
; CHECK-LABEL: @fdiv_op1_constant_fneg(
; CHECK-NEXT:    [[R:%.*]] = fdiv float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float %x, -42.0
  %r = fsub float -0.0, %d
  ret float %r
}

; Fast math is not required, but it should be propagated.

define float @fdiv_op1_constant_fneg_fmf(float %x) {
; CHECK-LABEL: @fdiv_op1_constant_fneg_fmf(
; CHECK-NEXT:    [[R:%.*]] = fdiv nnan float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float %x, -42.0
  %r = fsub nnan float -0.0, %d
  ret float %r
}

; Extra use prevents the fold. We don't want to replace the fneg with an fdiv.

define float @fdiv_op1_constant_fneg_extra_use(float %x) {
; CHECK-LABEL: @fdiv_op1_constant_fneg_extra_use(
; CHECK-NEXT:    [[D:%.*]] = fdiv float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[D]]
; CHECK-NEXT:    call void @use(float [[D]])
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float %x, 42.0
  %r = fsub float -0.0, %d
  call void @use(float %d)
  ret float %r
}

; Try a vector. Use special constants (NaN, INF, undef) because they don't change anything.

define <4 x double> @fdiv_op1_constant_fneg_vec(<4 x double> %x) {
; CHECK-LABEL: @fdiv_op1_constant_fneg_vec(
; CHECK-NEXT:    [[R:%.*]] = fdiv <4 x double> [[X:%.*]], <double 4.200000e+01, double 0x7FF800000ABCD000, double 0x7FF0000000000000, double 0x7FF8000000000000>
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %d = fdiv <4 x double> %x, <double -42.0, double 0xFFF800000ABCD000, double 0xFFF0000000000000, double undef>
  %r = fsub <4 x double> <double -0.0, double -0.0, double -0.0, double -0.0>, %d
  ret <4 x double> %r
}

; -(C / X) --> (-C) / X

define float @fdiv_op0_constant_fneg(float %x) {
; CHECK-LABEL: @fdiv_op0_constant_fneg(
; CHECK-NEXT:    [[R:%.*]] = fdiv float -4.200000e+01, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float 42.0, %x
  %r = fsub float -0.0, %d
  ret float %r
}

; Fast math is not required, but it should be propagated.

define float @fdiv_op0_constant_fneg_fmf(float %x) {
; CHECK-LABEL: @fdiv_op0_constant_fneg_fmf(
; CHECK-NEXT:    [[R:%.*]] = fdiv fast float -4.200000e+01, [[X:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float 42.0, %x
  %r = fsub fast float -0.0, %d
  ret float %r
}

; Extra use prevents the fold. We don't want to replace the fneg with an fdiv.

define float @fdiv_op0_constant_fneg_extra_use(float %x) {
; CHECK-LABEL: @fdiv_op0_constant_fneg_extra_use(
; CHECK-NEXT:    [[D:%.*]] = fdiv float -4.200000e+01, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fsub float -0.000000e+00, [[D]]
; CHECK-NEXT:    call void @use(float [[D]])
; CHECK-NEXT:    ret float [[R]]
;
  %d = fdiv float -42.0, %x
  %r = fsub float -0.0, %d
  call void @use(float %d)
  ret float %r
}

; Try a vector. Use special constants (NaN, INF, undef) because they don't change anything.

define <4 x double> @fdiv_op0_constant_fneg_vec(<4 x double> %x) {
; CHECK-LABEL: @fdiv_op0_constant_fneg_vec(
; CHECK-NEXT:    [[R:%.*]] = fdiv <4 x double> <double 4.200000e+01, double 0x7F80000000000000, double 0x7FF0000000000000, double 0x7FF8000000000000>, [[X:%.*]]
; CHECK-NEXT:    ret <4 x double> [[R]]
;
  %d = fdiv <4 x double> <double -42.0, double 0x7FF80000000000000, double 0xFFF0000000000000, double undef>, %x
  %r = fsub <4 x double> <double -0.0, double -0.0, double -0.0, double -0.0>, %d
  ret <4 x double> %r
}

; Actual fneg instructions.

define float @fneg_constant() {
; CHECK-LABEL: @fneg_constant(
; CHECK-NEXT:    [[R:%.*]] = fneg float -0.000000e+00
; CHECK-NEXT:    ret float [[R]]
;
  %r = fneg float -0.0
  ret float %r
}

define float @fneg_undef() {
; CHECK-LABEL: @fneg_undef(
; CHECK-NEXT:    [[R:%.*]] = fneg float undef
; CHECK-NEXT:    ret float [[R]]
;
  %r = fneg float undef
  ret float %r
}

define <4 x float> @fneg_constant_elts_v4f32() {
; CHECK-LABEL: @fneg_constant_elts_v4f32(
; CHECK-NEXT:    [[R:%.*]] = fneg <4 x float> <float -0.000000e+00, float 0.000000e+00, float -1.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %r = fneg <4 x float> <float -0.0, float 0.0, float -1.0, float 1.0>
  ret <4 x float> %r
}

define <4 x float> @fneg_constant_undef_elts_v4f32() {
; CHECK-LABEL: @fneg_constant_undef_elts_v4f32(
; CHECK-NEXT:    [[R:%.*]] = fneg <4 x float> <float -0.000000e+00, float undef, float undef, float 1.000000e+00>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %r = fneg <4 x float> <float -0.0, float undef, float undef, float 1.0>
  ret <4 x float> %r
}

define <4 x float> @fneg_constant_all_undef_elts_v4f32() {
; CHECK-LABEL: @fneg_constant_all_undef_elts_v4f32(
; CHECK-NEXT:    [[R:%.*]] = fneg <4 x float> undef
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %r = fneg <4 x float> <float undef, float undef, float undef, float undef>
  ret <4 x float> %r
}
