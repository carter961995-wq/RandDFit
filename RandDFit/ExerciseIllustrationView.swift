//
//  ExerciseIllustrationView.swift
//  RandDFit
//
//  Simple built-in visual depictions for exercises.
//

import SwiftUI

struct ExerciseIllustrationView: View {
    let kind: ExerciseKind

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(.secondarySystemBackground), Color(.tertiarySystemBackground)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            switch kind {
            case .pushUps:
                PushUpIllustration()
            case .airSquats:
                AirSquatIllustration()
            case .burpees:
                BurpeeIllustration()
            case .jumpingJacks:
                JumpingJackIllustration()
            case .mountainClimbers:
                MountainClimberIllustration()
            case .reverseLunges:
                ReverseLungeIllustration()
            case .highKnees:
                HighKneeIllustration()
            case .plank:
                PlankIllustration()
            }
        }
        .frame(height: 190)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(accessibilityLabel))
    }

    private var accessibilityLabel: String {
        switch kind {
        case .pushUps: return "Push-up form illustration"
        case .airSquats: return "Air squat form illustration"
        case .burpees: return "Burpee form illustration"
        case .jumpingJacks: return "Jumping jack form illustration"
        case .mountainClimbers: return "Mountain climber form illustration"
        case .reverseLunges: return "Reverse lunge form illustration"
        case .highKnees: return "High knees form illustration"
        case .plank: return "Plank form illustration"
        }
    }
}

// MARK: - Building blocks

private struct StickFigure: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Path { p in
                // Head
                let headR = min(w, h) * 0.08
                p.addEllipse(in: CGRect(x: w * 0.46, y: h * 0.10, width: headR * 2, height: headR * 2))

                // Body
                p.move(to: CGPoint(x: w * 0.50, y: h * 0.26))
                p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.55))

                // Arms
                p.move(to: CGPoint(x: w * 0.50, y: h * 0.34))
                p.addLine(to: CGPoint(x: w * 0.36, y: h * 0.44))
                p.move(to: CGPoint(x: w * 0.50, y: h * 0.34))
                p.addLine(to: CGPoint(x: w * 0.64, y: h * 0.44))

                // Legs
                p.move(to: CGPoint(x: w * 0.50, y: h * 0.55))
                p.addLine(to: CGPoint(x: w * 0.40, y: h * 0.78))
                p.move(to: CGPoint(x: w * 0.50, y: h * 0.55))
                p.addLine(to: CGPoint(x: w * 0.60, y: h * 0.78))
            }
            .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
        }
    }
}

private struct GroundLine: View {
    var body: some View {
        Rectangle()
            .fill(.primary.opacity(0.12))
            .frame(height: 3)
            .frame(maxWidth: .infinity)
    }
}

private struct LabelPill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.thinMaterial, in: Capsule())
            .foregroundStyle(.secondary)
    }
}

// MARK: - Exercise illustrations

private struct PushUpIllustration: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                VStack {
                    Spacer()
                    GroundLine().padding(.horizontal, w * 0.12)
                }

                Path { p in
                    // Body line
                    p.move(to: CGPoint(x: w * 0.22, y: h * 0.58))
                    p.addLine(to: CGPoint(x: w * 0.76, y: h * 0.46))
                    // Arms
                    p.move(to: CGPoint(x: w * 0.40, y: h * 0.55))
                    p.addLine(to: CGPoint(x: w * 0.44, y: h * 0.70))
                    p.addLine(to: CGPoint(x: w * 0.54, y: h * 0.70))
                    // Legs
                    p.move(to: CGPoint(x: w * 0.70, y: h * 0.48))
                    p.addLine(to: CGPoint(x: w * 0.78, y: h * 0.62))
                }
                .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))

                Circle()
                    .fill(.primary.opacity(0.9))
                    .frame(width: 18, height: 18)
                    .position(x: w * 0.18, y: h * 0.60)

                VStack {
                    HStack {
                        LabelPill(text: "Keep a straight line")
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    Spacer()
                }
            }
        }
    }
}

private struct PlankIllustration: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                VStack {
                    Spacer()
                    GroundLine().padding(.horizontal, w * 0.12)
                }

                Path { p in
                    p.move(to: CGPoint(x: w * 0.22, y: h * 0.55))
                    p.addLine(to: CGPoint(x: w * 0.80, y: h * 0.48))
                    // Forearms
                    p.move(to: CGPoint(x: w * 0.34, y: h * 0.54))
                    p.addLine(to: CGPoint(x: w * 0.36, y: h * 0.70))
                    // Legs
                    p.move(to: CGPoint(x: w * 0.72, y: h * 0.49))
                    p.addLine(to: CGPoint(x: w * 0.82, y: h * 0.64))
                }
                .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))

                Circle()
                    .fill(.primary.opacity(0.9))
                    .frame(width: 18, height: 18)
                    .position(x: w * 0.18, y: h * 0.57)

                VStack {
                    HStack {
                        LabelPill(text: "Hips level")
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    Spacer()
                }
            }
        }
    }
}

private struct AirSquatIllustration: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                VStack {
                    Spacer()
                    GroundLine().padding(.horizontal, w * 0.18)
                }

                Path { p in
                    // Head
                    p.addEllipse(in: CGRect(x: w * 0.47, y: h * 0.12, width: 18, height: 18))
                    // Torso
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.22))
                    p.addLine(to: CGPoint(x: w * 0.47, y: h * 0.44))
                    // Thighs (squat)
                    p.move(to: CGPoint(x: w * 0.47, y: h * 0.44))
                    p.addLine(to: CGPoint(x: w * 0.38, y: h * 0.52))
                    p.move(to: CGPoint(x: w * 0.47, y: h * 0.44))
                    p.addLine(to: CGPoint(x: w * 0.58, y: h * 0.52))
                    // Shins
                    p.move(to: CGPoint(x: w * 0.38, y: h * 0.52))
                    p.addLine(to: CGPoint(x: w * 0.40, y: h * 0.70))
                    p.move(to: CGPoint(x: w * 0.58, y: h * 0.52))
                    p.addLine(to: CGPoint(x: w * 0.60, y: h * 0.70))
                    // Arms forward
                    p.move(to: CGPoint(x: w * 0.48, y: h * 0.30))
                    p.addLine(to: CGPoint(x: w * 0.34, y: h * 0.32))
                    p.move(to: CGPoint(x: w * 0.48, y: h * 0.30))
                    p.addLine(to: CGPoint(x: w * 0.64, y: h * 0.32))
                }
                .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 6.5, lineCap: .round, lineJoin: .round))

                VStack {
                    HStack {
                        LabelPill(text: "Hips back, chest up")
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    Spacer()
                }
            }
        }
    }
}

private struct JumpingJackIllustration: View {
    var body: some View {
        ZStack {
            StickFigure()
                .padding(.horizontal, 40)
                .padding(.vertical, 18)

            VStack {
                HStack {
                    LabelPill(text: "Arms up, feet out")
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.top, 12)
                Spacer()
            }
        }
    }
}

private struct ReverseLungeIllustration: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                VStack {
                    Spacer()
                    GroundLine().padding(.horizontal, w * 0.16)
                }

                Path { p in
                    // Head
                    p.addEllipse(in: CGRect(x: w * 0.44, y: h * 0.12, width: 18, height: 18))
                    // Torso
                    p.move(to: CGPoint(x: w * 0.47, y: h * 0.22))
                    p.addLine(to: CGPoint(x: w * 0.47, y: h * 0.50))
                    // Front leg (bent)
                    p.move(to: CGPoint(x: w * 0.47, y: h * 0.50))
                    p.addLine(to: CGPoint(x: w * 0.40, y: h * 0.58))
                    p.addLine(to: CGPoint(x: w * 0.45, y: h * 0.72))
                    // Back leg (extended)
                    p.move(to: CGPoint(x: w * 0.47, y: h * 0.50))
                    p.addLine(to: CGPoint(x: w * 0.58, y: h * 0.64))
                    p.addLine(to: CGPoint(x: w * 0.62, y: h * 0.72))
                    // Arms
                    p.move(to: CGPoint(x: w * 0.47, y: h * 0.32))
                    p.addLine(to: CGPoint(x: w * 0.38, y: h * 0.40))
                    p.move(to: CGPoint(x: w * 0.47, y: h * 0.32))
                    p.addLine(to: CGPoint(x: w * 0.56, y: h * 0.40))
                }
                .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 6.5, lineCap: .round, lineJoin: .round))

                VStack {
                    HStack {
                        LabelPill(text: "Knee tracks over toes")
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    Spacer()
                }
            }
        }
    }
}

private struct HighKneeIllustration: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                VStack {
                    Spacer()
                    GroundLine().padding(.horizontal, w * 0.20)
                }

                Path { p in
                    // Head
                    p.addEllipse(in: CGRect(x: w * 0.47, y: h * 0.12, width: 18, height: 18))
                    // Torso
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.22))
                    p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.52))
                    // Arms pumping
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.32))
                    p.addLine(to: CGPoint(x: w * 0.40, y: h * 0.40))
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.34))
                    p.addLine(to: CGPoint(x: w * 0.62, y: h * 0.28))
                    // Legs: one knee up
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.52))
                    p.addLine(to: CGPoint(x: w * 0.42, y: h * 0.52))
                    p.addLine(to: CGPoint(x: w * 0.40, y: h * 0.66))
                    p.move(to: CGPoint(x: w * 0.50, y: h * 0.52))
                    p.addLine(to: CGPoint(x: w * 0.58, y: h * 0.68))
                }
                .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 6.5, lineCap: .round, lineJoin: .round))

                VStack {
                    HStack {
                        LabelPill(text: "Drive knees up")
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    Spacer()
                }
            }
        }
    }
}

private struct MountainClimberIllustration: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                VStack {
                    Spacer()
                    GroundLine().padding(.horizontal, w * 0.12)
                }

                Path { p in
                    // Body line (plank-ish)
                    p.move(to: CGPoint(x: w * 0.24, y: h * 0.54))
                    p.addLine(to: CGPoint(x: w * 0.78, y: h * 0.44))
                    // Arms
                    p.move(to: CGPoint(x: w * 0.38, y: h * 0.52))
                    p.addLine(to: CGPoint(x: w * 0.42, y: h * 0.70))
                    p.addLine(to: CGPoint(x: w * 0.52, y: h * 0.70))
                    // Legs: one knee pulled in
                    p.move(to: CGPoint(x: w * 0.66, y: h * 0.46))
                    p.addLine(to: CGPoint(x: w * 0.58, y: h * 0.62))
                    p.addLine(to: CGPoint(x: w * 0.62, y: h * 0.70))
                    // Back leg extended
                    p.move(to: CGPoint(x: w * 0.74, y: h * 0.45))
                    p.addLine(to: CGPoint(x: w * 0.82, y: h * 0.64))
                }
                .stroke(.primary.opacity(0.9), style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))

                Circle()
                    .fill(.primary.opacity(0.9))
                    .frame(width: 18, height: 18)
                    .position(x: w * 0.20, y: h * 0.56)

                VStack {
                    HStack {
                        LabelPill(text: "Hands under shoulders")
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    Spacer()
                }
            }
        }
    }
}

private struct BurpeeIllustration: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                VStack {
                    Spacer()
                    GroundLine().padding(.horizontal, w * 0.16)
                }

                HStack(spacing: 14) {
                    // Start (stand)
                    StickFigure()
                        .frame(width: w * 0.34, height: h * 0.86)

                    Image(systemName: "arrow.right")
                        .foregroundStyle(.secondary)

                    // End (plank)
                    PushUpIllustration()
                        .frame(width: w * 0.46, height: h * 0.86)
                }
                .padding(.horizontal, 14)

                VStack {
                    HStack {
                        LabelPill(text: "Stand → squat → plank")
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ExerciseIllustrationView(kind: .pushUps)
        .padding()
}

