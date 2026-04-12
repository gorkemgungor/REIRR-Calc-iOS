import SwiftUI

struct CourseView: View {
    let title: String
    @ObservedObject var course: CourseData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 4)

            Group {
                InputRow(label: "Total Dose (Gy)", value: $course.totalDose)
                InputRow(label: "# of Fractions",  value: $course.nFractions)
                InputRow(label: "Dose/Fr. (Gy)",   value: $course.doseFr)
            }

            Divider().background(Color.gray)

            Group {
                ResultRow(label: "EQD2 (α/β=3)",   value: course.eqd2_3)
                ResultRow(label: "BED (α/β=3)",     value: course.bed_3)
                ResultRow(label: "EQD2 (α/β=10)",   value: course.eqd2_10)
                ResultRow(label: "BED (α/β=10)",    value: course.bed_10)
            }

            HStack {
                Text("Manual α/β:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Picker("", selection: $course.manualAB) {
                    ForEach(stride(from: 0.5, through: 10.5, by: 0.5).map { $0 }, id: \.self) { v in
                        Text(String(format: "%.1f", v)).tag(v)
                    }
                }
                .pickerStyle(.menu)
                .tint(.blue)
            }

            ResultRow(label: "EQD2 (manual)", value: course.eqd2_man)
            ResultRow(label: "BED (manual)",  value: course.bed_man)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InputRow: View {
    let label: String
    @Binding var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            TextField("0", text: $value)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
                .padding(4)
                .background(Color(.systemGray5))
                .cornerRadius(6)
                .foregroundColor(.white)
        }
    }
}

struct ResultRow: View {
    let label: String
    let value: Double

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            Text(String(format: "%.2f", value))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}
